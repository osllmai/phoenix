"""Authenticated accounts surface (allauth headless X-Session-Token)."""
from __future__ import annotations

import os
import random
from uuid import uuid4

from locust.exception import StopUser

import checks as c
import contracts as s

LOCALES = ['en', 'fa', 'de', 'fr']


def get_me(user):
    with user.client.get('/api/v1/accounts/me/', name='GET /accounts/me/', catch_response=True) as r, c.contract(r) as body:
        c.expect_object(body, s.USER_ME)
        if '@' not in body['email']:
            raise c.ContractError(f'email={body["email"]!r} is not an address')


def patch_me(user):
    payload = {'full_name': f'Load Test {uuid4().hex[:6]}', 'locale': random.choice(LOCALES)}
    with user.client.patch('/api/v1/accounts/me/', json=payload, name='PATCH /accounts/me/', catch_response=True) as r, c.contract(r) as body:
        c.expect_object(body, s.USER_ME)
        for field, value in payload.items():
            if body[field] != value:
                raise c.ContractError(f'{field}={body[field]!r} not persisted (sent {value!r})')


def export_me(user):
    with user.client.post('/api/v1/accounts/me/export/', name='POST /accounts/me/export/', catch_response=True) as r, c.contract(r) as body:
        c.expect_object(body, s.USER_EXPORT)
        c.expect_object(body['user'], s.USER_ME, 'user')


def delete_me(user):
    with user.client.delete('/api/v1/accounts/me/', name='DELETE /accounts/me/', catch_response=True) as r, c.contract(r) as body:
        c.expect_object(body, {'status': str})
        if body['status'] != 'deleted':
            raise c.ContractError(f'status={body["status"]!r}, expected "deleted"')
    raise StopUser()


TASKS = {get_me: 6, patch_me: 3, export_me: 1}

if os.getenv('PHOENIX_ALLOW_ACCOUNT_DELETE') == '1':
    TASKS[delete_me] = 1
