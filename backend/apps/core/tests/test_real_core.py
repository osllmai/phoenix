"""core — A6 real-lane sibling.

core mounts no router of its own, so its live-stack proof is the surface it does
own: the public health probe and the schema the running server actually serves.

Fails closed on production (see backend/tests/_real.py).
"""
from __future__ import annotations

import pytest

from tests._real import json_of, resolve_stack_url, status_of

pytestmark = pytest.mark.real

HEALTH = "/api/v1/health/"
SCHEMA = "/api/v1/openapi.json"


@pytest.fixture(scope="module")
def stack_url() -> str:
    return resolve_stack_url()


def test_the_live_health_probe_is_public(stack_url):
    assert status_of(f"{stack_url}{HEALTH}") == 200, "health is public by contract"


def test_the_live_surface_returns_no_5xx(stack_url):
    assert status_of(f"{stack_url}{SCHEMA}") < 500


def test_the_running_server_serves_a_schema_with_operations(stack_url):
    served = json_of(f"{stack_url}{SCHEMA}")
    assert served.get("paths"), "the running server serves a schema with no operations"
