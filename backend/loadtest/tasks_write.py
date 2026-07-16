"""Contended writes: fleet fan-out/merge and the extension install counter."""
from __future__ import annotations

import random
from uuid import uuid4

import checks as c
import contracts as s
import seed
from tasks_read import RUN_DETAIL_NAME

BRANCHES = ['app/developer', 'app/auth', 'production']


def create_fleet_run(user):
    agents = random.sample(seed.AGENTS, random.randint(2, 4))
    payload = {
        'prompt': f'loadtest fan-out {uuid4().hex[:8]}',
        'agents': agents,
        'base_branch': random.choice(BRANCHES),
        'race_mode': random.choice([True, False]),
    }
    with user.client.post('/api/v1/fleet/runs/', json=payload, name='POST /fleet/runs/', catch_response=True) as r, c.contract(r) as body:
        c.expect_object(body, s.RUN_DETAIL)
        c.expect_list(body['lanes'], s.LANE, 'lanes', sample=None)
        if len(body['lanes']) != len(agents):
            raise c.ContractError(f'sent {len(agents)} agents, got {len(body["lanes"])} lanes')
        if body['prompt'] != payload['prompt'] or body['base_branch'] != payload['base_branch']:
            raise c.ContractError('run did not echo back the prompt/base_branch it was created with')
        seed.remember(seed.runs, body['id'])


def _lane_ids(user, run_id: int) -> list[int]:
    with user.client.get(f'/api/v1/fleet/runs/{run_id}/', name=RUN_DETAIL_NAME, catch_response=True) as r, c.contract(r) as body:
        c.expect_object(body, s.RUN_DETAIL)
        return [lane['id'] for lane in body['lanes']]
    return []


def merge_winner(user):
    run_id = seed.pick(seed.runs)
    if run_id is None:
        return
    lane_ids = _lane_ids(user, run_id)
    if not lane_ids:
        return
    payload = {'lane_id': random.choice(lane_ids), 'target_branch': random.choice(BRANCHES)}
    with user.client.post(f'/api/v1/fleet/runs/{run_id}/merge/', json=payload, name='POST /fleet/runs/{id}/merge/', catch_response=True) as r, c.contract(r) as body:
        c.expect_object(body, s.RUN_DETAIL)
        c.expect_list(body['lanes'], s.LANE, 'lanes', sample=None)
        if body['status'] != 'merged':
            raise c.ContractError(f'status={body["status"]!r} after merge, expected "merged"')
        winners = [lane['id'] for lane in body['lanes'] if lane['is_winner']]
        if len(winners) != 1:
            raise c.ContractError(
                f'run {run_id}: {len(winners)} winner lanes {winners}, expected exactly 1 '
                '— unguarded merge (3 writes, no transaction.atomic)'
            )


def install_extension(user):
    slug = seed.pick(seed.slugs)
    if slug is None:
        return
    with user.client.post(f'/api/v1/extensions/{slug}/install/', name='POST /extensions/{slug}/install/', catch_response=True) as r, c.contract(r) as body:
        c.expect_object(body, s.EXTENSION_DETAIL)
        if body['slug'] != slug:
            raise c.ContractError(f'installed {slug!r}, got {body["slug"]!r} back')
        if not body['installed']:
            raise c.ContractError(f'{slug!r} installed=false immediately after install — lost update')
        if body['installs_count'] < 1:
            raise c.ContractError(f'installs_count={body["installs_count"]} after an F()+1 increment')


def uninstall_extension(user):
    slug = seed.pick(seed.slugs)
    if slug is None:
        return
    with user.client.post(f'/api/v1/extensions/{slug}/uninstall/', name='POST /extensions/{slug}/uninstall/', catch_response=True) as r, c.contract(r) as body:
        c.expect_object(body, s.EXTENSION_DETAIL)
        if body['slug'] != slug:
            raise c.ContractError(f'uninstalled {slug!r}, got {body["slug"]!r} back')
        if body['installed']:
            raise c.ContractError(f'{slug!r} installed=true immediately after uninstall — lost update')
