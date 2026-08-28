"""accounts — A6 real-lane sibling.

Against the running stack: real Postgres, real Redis, real Celery, real HTTP.
Small and chosen — this lane is slow, so it proves what the stubs cannot:
wiring, serialization across a genuine HTTP boundary, and applied migrations.

Fails closed on production (see backend/tests/_real.py).
"""
from __future__ import annotations

import pytest

from tests._real import assert_refuses_anonymous, resolve_stack_url, status_of

pytestmark = pytest.mark.real

ME = "/api/v1/accounts/me/"
EXPORT = "/api/v1/accounts/me/export/"


@pytest.fixture(scope="module")
def stack_url() -> str:
    return resolve_stack_url()


def test_the_live_surface_refuses_an_anonymous_caller(stack_url):
    assert_refuses_anonymous(f"{stack_url}{ME}")


def test_the_live_surface_returns_no_5xx(stack_url):
    assert status_of(f"{stack_url}{ME}") < 500
    assert status_of(f"{stack_url}{EXPORT}") < 500

