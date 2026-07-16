"""Shared id pool. Seeded once at test start so no task ever hardcodes an id."""
from __future__ import annotations

import logging
import os
import random

import requests

logger = logging.getLogger('phoenix.loadtest')

AGENTS = ['claude', 'codex', 'gemini', 'cursor', 'aider']
MAX_POOL = 200

runs: list[int] = []
documents: list[int] = []
searches: list[int] = []
jobs: list[str] = []
slugs: list[str] = []


def pick(pool: list):
    return random.choice(pool) if pool else None


def remember(pool: list, value) -> None:
    if len(pool) < MAX_POOL:
        pool.append(value)


def _count(name: str, default: int) -> int:
    return int(os.getenv(name, str(default)))


def _post(session, base: str, path: str, payload: dict) -> dict:
    response = session.post(f'{base}{path}', json=payload, timeout=30)
    response.raise_for_status()
    return response.json()


def seed(host: str | None) -> None:
    if not host:
        raise ValueError('no host — pass --host http://localhost:37000 or set LOCUST_HOST')
    base = host.rstrip('/')
    session = requests.Session()

    catalog = session.get(f'{base}/api/v1/extensions/', timeout=30)
    catalog.raise_for_status()
    slugs.extend(item['slug'] for item in catalog.json())
    if not slugs:
        logger.warning('extensions catalog is EMPTY — extension tasks will no-op; seed it (see README)')

    for i in range(_count('PHOENIX_SEED_RUNS', 3)):
        run = _post(session, base, '/api/v1/fleet/runs/', {
            'prompt': f'loadtest seed run {i}',
            'agents': AGENTS[:4],
            'base_branch': 'app/developer',
            'race_mode': True,
        })
        runs.append(run['id'])

    for i in range(_count('PHOENIX_SEED_DOCS', 3)):
        doc = _post(session, base, '/api/v1/documents/', {
            'title': f'loadtest seed doc {i}',
            'source_path': f'/loadtest/seed-{i}.pdf',
        })
        documents.append(doc['id'])
        jobs.append(doc['job_id'])

    for i in range(_count('PHOENIX_SEED_SEARCHES', 2)):
        search = _post(session, base, '/api/v1/deepsearch/', {'query': f'loadtest seed query {i}'})
        searches.append(search['id'])
        jobs.append(search['job_id'])

    logger.info(
        'seeded: runs=%s documents=%s searches=%s jobs=%d extensions=%d',
        runs, documents, searches, len(jobs), len(slugs),
    )
