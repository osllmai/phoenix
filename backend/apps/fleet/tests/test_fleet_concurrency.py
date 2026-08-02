"""Concurrency contract for the fleet merge endpoint.

Invariant: after any number of concurrent merges on one run, exactly one lane
carries is_winner, and the run's base_branch belongs to that same merge call.
"""
import threading
from concurrent.futures import ThreadPoolExecutor

import pytest
from django import db
from ninja.testing import TestClient

from apps.fleet.api import router
from apps.fleet.models import FleetLane, FleetRun

pytestmark = pytest.mark.django_db(transaction=True)

LANES = 8
ROUNDS = 5


@pytest.fixture
def client():
    return TestClient(router)


def _make_run():
    run = FleetRun.objects.create(prompt='race the merge')
    lanes = [
        FleetLane.objects.create(run=run, agent=f'agent-{i}', worktree_path=f'wt-{i}')
        for i in range(LANES)
    ]
    return run, lanes


def _merge(client, barrier, run_id, lane_id, target_branch):
    try:
        barrier.wait(timeout=10)
        resp = client.post(
            f'/runs/{run_id}/merge/',
            json={'lane_id': lane_id, 'target_branch': target_branch},
        )
        return resp.status_code
    finally:
        db.connection.close()


def _race_merges(client, run, lanes, branch_of):
    barrier = threading.Barrier(len(lanes))
    with ThreadPoolExecutor(max_workers=len(lanes)) as pool:
        futures = [
            pool.submit(_merge, client, barrier, run.id, lane.id, branch_of(lane))
            for lane in lanes
        ]
        return [f.result() for f in futures]


def test_concurrent_merges_leave_exactly_one_winner(client):
    winner_counts = []
    for _ in range(ROUNDS):
        run, lanes = _make_run()
        statuses = _race_merges(client, run, lanes, lambda lane: 'production')
        assert set(statuses) == {200}
        winner_counts.append(FleetLane.objects.filter(run=run, is_winner=True).count())

    assert winner_counts == [1] * ROUNDS, (
        f'merge_winner is not atomic: winners per round = {winner_counts} '
        f'(expected exactly 1 each, saw {sorted(set(winner_counts))})'
    )


def test_concurrent_merges_leave_run_state_consistent(client):
    run, lanes = _make_run()
    statuses = _race_merges(client, run, lanes, lambda lane: f'branch-{lane.id}')
    assert set(statuses) == {200}

    run.refresh_from_db()
    assert run.status == 'merged'

    winners = list(FleetLane.objects.filter(run=run, is_winner=True))
    assert len(winners) == 1, f'expected 1 winner, found {len(winners)}'
    assert run.base_branch == f'branch-{winners[0].id}', (
        f'run.base_branch={run.base_branch!r} came from a different merge call '
        f'than the winning lane {winners[0].id}'
    )
