"""Read traffic — the bulk of the mix. Every response is contract-checked."""
from __future__ import annotations

import random

import checks as c
import contracts as s
import seed

RUN_DETAIL_NAME = 'GET /fleet/runs/{id}/'
DOC_DETAIL_NAME = 'GET /documents/{id}/'


def health(user):
    with user.client.get('/api/v1/health/', name='GET /health/', catch_response=True) as r, c.contract(r) as body:
        c.expect_object(body, s.HEALTH)
        if body['status'] != 'ok':
            raise c.ContractError(f'status={body["status"]!r}, expected "ok"')


def list_fleet_runs(user):
    params = random.choice([{}, {'status': 'running'}, {'status': 'merged'}])
    with user.client.get('/api/v1/fleet/runs/', params=params, name='GET /fleet/runs/', catch_response=True) as r, c.contract(r) as body:
        c.expect_list(body, s.RUN_LIST, 'runs')
        wanted = params.get('status')
        leaked = [row['id'] for row in body if wanted and row['status'] != wanted]
        if leaked:
            raise c.ContractError(f'status={wanted!r} filter leaked runs {leaked[:5]}')


def get_fleet_run(user):
    run_id = seed.pick(seed.runs)
    if run_id is None:
        return
    with user.client.get(f'/api/v1/fleet/runs/{run_id}/', name=RUN_DETAIL_NAME, catch_response=True) as r, c.contract(r) as body:
        c.expect_object(body, s.RUN_DETAIL)
        c.expect_list(body['lanes'], s.LANE, 'lanes')
        c.expect_list(body['events'], s.EVENT, 'events')
        if body['id'] != run_id:
            raise c.ContractError(f'asked for run {run_id}, got {body["id"]}')


def list_extensions(user):
    with user.client.get('/api/v1/extensions/', name='GET /extensions/', catch_response=True) as r, c.contract(r) as body:
        c.expect_list(body, s.EXTENSION_LIST, 'extensions')


def search_extensions(user):
    params = random.choice([
        {'category': 'developer'}, {'category': 'search'}, {'category': 'document'},
        {'q': 'a'}, {'q': 'search'},
    ])
    with user.client.get('/api/v1/extensions/', params=params, name='GET /extensions/?filter', catch_response=True) as r, c.contract(r) as body:
        c.expect_list(body, s.EXTENSION_LIST, 'extensions')
        category = params.get('category')
        leaked = [row['slug'] for row in body if category and row['category'] != category]
        if leaked:
            raise c.ContractError(f'category={category!r} filter leaked {leaked[:5]}')


def get_extension(user):
    slug = seed.pick(seed.slugs)
    if slug is None:
        return
    with user.client.get(f'/api/v1/extensions/{slug}/', name='GET /extensions/{slug}/', catch_response=True) as r, c.contract(r) as body:
        c.expect_object(body, s.EXTENSION_DETAIL)
        if body['slug'] != slug:
            raise c.ContractError(f'asked for {slug!r}, got {body["slug"]!r}')


def list_documents(user):
    with user.client.get('/api/v1/documents/', name='GET /documents/', catch_response=True) as r, c.contract(r) as body:
        c.expect_list(body, s.DOCUMENT_LIST, 'documents')


def get_document(user):
    document_id = seed.pick(seed.documents)
    if document_id is None:
        return
    with user.client.get(f'/api/v1/documents/{document_id}/', name=DOC_DETAIL_NAME, catch_response=True) as r, c.contract(r) as body:
        c.expect_object(body, s.DOCUMENT_DETAIL)
        if body['id'] != document_id:
            raise c.ContractError(f'asked for document {document_id}, got {body["id"]}')


def list_searches(user):
    with user.client.get('/api/v1/deepsearch/', name='GET /deepsearch/', catch_response=True) as r, c.contract(r) as body:
        c.expect_list(body, s.SEARCH_LIST, 'searches')


def get_search(user):
    run_id = seed.pick(seed.searches)
    if run_id is None:
        return
    with user.client.get(f'/api/v1/deepsearch/{run_id}/', name='GET /deepsearch/{id}/', catch_response=True) as r, c.contract(r) as body:
        c.expect_object(body, s.SEARCH_DETAIL)
        if body['id'] != run_id:
            raise c.ContractError(f'asked for search {run_id}, got {body["id"]}')


def poll_job(user):
    job_id = seed.pick(seed.jobs)
    if job_id is None:
        return
    with user.client.get(f'/api/v1/ai-chat/jobs/{job_id}/', name='GET /ai-chat/jobs/{id}/', catch_response=True) as r, c.contract(r) as body:
        c.expect_object(body, s.JOB)
        if body['job_id'] != job_id:
            raise c.ContractError(f'asked for job {job_id}, got {body["job_id"]}')
        if body['status'] not in s.JOB_STATES:
            raise c.ContractError(f'unknown celery state {body["status"]!r}')
