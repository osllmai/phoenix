import pytest
from ninja.testing import TestClient

from apps.fleet.api import router
from apps.fleet.models import FleetEvent, FleetLane, FleetRun

pytestmark = pytest.mark.django_db


@pytest.fixture
def client():
    return TestClient(router)


@pytest.fixture
def run():
    r = FleetRun.objects.create(prompt='add OAuth login + tests')
    FleetLane.objects.create(
        run=r, agent='claude-code', worktree_path='phoenix-cc-1', state='done',
        status_label='done', additions=128, deletions=14, files_changed=3, is_winner=True,
    )
    FleetLane.objects.create(
        run=r, agent='codex', worktree_path='phoenix-cx-2', state='running',
        status_label='running',
    )
    FleetEvent.objects.create(run=r, at='10:42', actor='maestro', text='· 4 worktrees', outcome='fan out')
    return r


def test_model_str_and_defaults(run):
    assert run.status == 'running'
    assert run.race_mode is True
    assert run.base_branch == 'app/developer'
    assert str(run).startswith('add OAuth login + tests')
    lane = run.lanes.get(agent='codex')
    assert lane.route == 'local'
    assert str(lane) == 'codex@phoenix-cx-2'


def test_list_runs(client, run):
    resp = client.get('/runs/')
    assert resp.status_code == 200
    row = resp.json()[0]
    assert row['prompt'] == 'add OAuth login + tests'
    assert row['lane_count'] == 2
    assert row['done_count'] == 1


def test_list_status_filter(client, run):
    assert client.get('/runs/?status=merged').json() == []
    running_ids = {r['id'] for r in client.get('/runs/?status=running').json()}
    assert run.id in running_ids


def test_get_run_detail(client, run):
    resp = client.get(f'/runs/{run.id}/')
    assert resp.status_code == 200
    body = resp.json()
    assert len(body['lanes']) == 2
    assert len(body['events']) == 1
    assert {'agent', 'worktree_path', 'state', 'is_winner'} <= set(body['lanes'][0].keys())


def test_get_run_404(client):
    assert client.get('/runs/9999/').status_code == 404


def test_fan_out_creates_run_and_lanes(client):
    resp = client.post('/runs/', json={'prompt': 'speed up search', 'agents': ['claude-code', 'codex']})
    assert resp.status_code == 200
    body = resp.json()
    assert body['prompt'] == 'speed up search'
    assert [lane['agent'] for lane in body['lanes']] == ['claude-code', 'codex']
    assert body['lanes'][0]['worktree_path'] == 'phoenix-cl-1'
    assert all(lane['state'] == 'queued' for lane in body['lanes'])


def test_merge_winner(client, run):
    loser = run.lanes.get(agent='codex')
    resp = client.post(f'/runs/{run.id}/merge/', json={'lane_id': loser.id, 'target_branch': 'production'})
    assert resp.status_code == 200
    body = resp.json()
    assert body['status'] == 'merged'
    assert body['base_branch'] == 'production'
    winners = [lane for lane in body['lanes'] if lane['is_winner']]
    assert len(winners) == 1 and winners[0]['agent'] == 'codex'


def test_merge_lane_from_other_run_404(client, run):
    other = FleetRun.objects.create(prompt='other')
    stray = FleetLane.objects.create(run=other, agent='x', worktree_path='p')
    assert client.post(f'/runs/{run.id}/merge/', json={'lane_id': stray.id}).status_code == 404


def test_seed_migration_populated(client):
    seeded = FleetRun.objects.filter(prompt='add OAuth login + tests')
    assert seeded.exists()
    run = seeded.first()
    assert run.lanes.filter(is_winner=True).count() == 1
    assert run.lanes.count() == 4
    assert run.events.count() == 4
