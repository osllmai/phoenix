"""The run list counts lanes in SQL, so its query count cannot grow with rows."""
import pytest
from django.db import connection
from django.test.utils import CaptureQueriesContext
from ninja.testing import TestClient

from apps.fleet.api import router
from apps.fleet.models import FleetLane, FleetRun

pytestmark = pytest.mark.django_db


@pytest.fixture
def client():
    return TestClient(router)


def make_run(lanes: int = 2, done: int = 1) -> FleetRun:
    run = FleetRun.objects.create(prompt='ship the fleet list')
    for i in range(lanes):
        FleetLane.objects.create(
            run=run, agent=f'agent-{i}', worktree_path=f'phoenix-a{i}',
            state='done' if i < done else 'running',
        )
    return run


def count_queries(call) -> int:
    with CaptureQueriesContext(connection) as captured:
        call()
    return len(captured)


def test_the_list_query_count_does_not_grow_with_rows(client):
    make_run()
    at_one = count_queries(lambda: client.get('/runs/'))

    for _ in range(7):
        make_run()
    at_many = count_queries(lambda: client.get('/runs/'))

    assert at_one == at_many, (
        f'{at_one} query(s) at 1 row, {at_many} at 8 — the count grows with the rows'
    )


def test_the_counts_are_still_right(client):
    make_run(lanes=3, done=2)

    row = client.get('/runs/').json()[0]

    assert row['lane_count'] == 3
    assert row['done_count'] == 2


def test_a_run_without_lanes_counts_zero(client):
    FleetRun.objects.create(prompt='no lanes yet')

    row = client.get('/runs/').json()[0]

    assert row['lane_count'] == 0
    assert row['done_count'] == 0


def test_the_newest_run_is_still_listed_first(client):
    make_run()
    newest = FleetRun.objects.create(prompt='newest')

    assert client.get('/runs/').json()[0]['id'] == newest.pk
