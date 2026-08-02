"""Writes that enqueue Celery work: deepsearch, ai-chat, documents."""
from __future__ import annotations

import random
from uuid import uuid4

import checks as c
import contracts as s
import seed
from tasks_read import DOC_DETAIL_NAME

SCOPES = ['local', 'web']
DEPTHS = ['quick', 'standard', 'deep']


def start_deepsearch(user):
    payload = {
        'query': f'loadtest deepsearch {uuid4().hex[:8]}',
        'scope': random.choice(SCOPES),
        'depth': random.choice(DEPTHS),
    }
    with user.client.post('/api/v1/deepsearch/', json=payload, name='POST /deepsearch/', catch_response=True) as r, c.contract(r) as body:
        c.expect_object(body, s.SEARCH_STARTED)
        if body['status'] != 'pending':
            raise c.ContractError(f'status={body["status"]!r} on start, expected "pending"')
        if not body['job_id']:
            raise c.ContractError('empty job_id — the celery task was never enqueued')
        seed.remember(seed.searches, body['id'])
        seed.remember(seed.jobs, body['job_id'])


def start_ai_chat_deep_search(user):
    payload = {'query': f'loadtest ai-chat {uuid4().hex[:8]}'}
    with user.client.post('/api/v1/ai-chat/deep-search/', json=payload, name='POST /ai-chat/deep-search/', catch_response=True) as r, c.contract(r) as body:
        c.expect_object(body, s.JOB)
        if body['status'] != 'queued':
            raise c.ContractError(f'status={body["status"]!r} on enqueue, expected "queued"')
        if not body['job_id']:
            raise c.ContractError('empty job_id — the celery task was never enqueued')
        seed.remember(seed.jobs, body['job_id'])


def _create_document(user, title: str) -> int | None:
    payload = {'title': title, 'source_path': f'/loadtest/{uuid4().hex[:8]}.pdf'}
    with user.client.post('/api/v1/documents/', json=payload, name='POST /documents/', catch_response=True) as r, c.contract(r) as body:
        c.expect_object(body, s.DOCUMENT_CREATED)
        if body['title'] != title:
            raise c.ContractError(f'title={body["title"]!r} not echoed back (sent {title!r})')
        if body['status'] != 'pending':
            raise c.ContractError(f'status={body["status"]!r} on create, expected "pending"')
        if not body['job_id']:
            raise c.ContractError('empty job_id — the convert task was never enqueued')
        return body['id']
    return None


def create_document(user):
    document_id = _create_document(user, f'loadtest doc {uuid4().hex[:8]}')
    if document_id is not None:
        seed.remember(seed.documents, document_id)


def create_and_delete_document(user):
    document_id = _create_document(user, f'loadtest ephemeral {uuid4().hex[:8]}')
    if document_id is None:
        return
    with user.client.delete(f'/api/v1/documents/{document_id}/', name='DELETE /documents/{id}/', catch_response=True) as r, c.contract(r) as body:
        c.expect_object(body, s.DOCUMENT_DELETED)
        if body['deleted'] != document_id:
            raise c.ContractError(f'deleted {body["deleted"]}, asked for {document_id}')
    with user.client.get(f'/api/v1/documents/{document_id}/', name=f'{DOC_DETAIL_NAME} [deleted -> 404]', catch_response=True) as r, c.contract(r, status=404) as body:
        c.expect_object(body, s.NOT_FOUND)
