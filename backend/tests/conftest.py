"""Fixtures shared by the repo-level sweeps in this package.

The per-user identity fixtures (`user`, `other_user`, `auth_headers`,
`other_headers`) come from backend/conftest.py and are reused, never duplicated.
"""
from __future__ import annotations

from typing import Any

import pytest
from django.test import Client

from . import _factories as f
from . import _urls
from ._ops import Operation, all_ops, openapi_document
from ._urls import send  # noqa: F401 — re-exported for the sweep modules


@pytest.fixture
def sweep_client() -> Client:
    return Client()


@pytest.fixture(autouse=True)
def eager_celery(settings) -> None:
    """Sweeps must never need a broker; the mock lane touches no socket."""
    settings.CELERY_TASK_ALWAYS_EAGER = True
    settings.CELERY_TASK_EAGER_PROPAGATES = True


@pytest.fixture
def document() -> dict[str, Any]:
    return openapi_document()


@pytest.fixture
def ops() -> list[Operation]:
    return all_ops()


@pytest.fixture
def owned_rows(db, user) -> dict[str, Any]:
    """One row of every owned model, all belonging to `user`."""
    run = f.make_fleet_run(owner=user)
    return {
        "document": f.make_document(owner=user),
        "search": f.make_search_run(owner=user),
        "extension": f.make_extension(),
        "fleet_run": run,
        "fleet_lane": f.make_fleet_lane(run),
    }


@pytest.fixture
def foreign_rows(db, other_user) -> dict[str, Any]:
    """The same set, owned by a second account — the IDOR/tenant counterpart."""
    run = f.make_fleet_run(owner=other_user)
    return {
        "document": f.make_document(owner=other_user),
        "search": f.make_search_run(owner=other_user),
        "extension": f.make_extension(),
        "fleet_run": run,
        "fleet_lane": f.make_fleet_lane(run),
    }


@pytest.fixture
def url_for(owned_rows):
    def build(op: Operation) -> str:
        return _urls.url_for(op, owned_rows)

    return build


@pytest.fixture
def foreign_url_for(foreign_rows):
    def build(op: Operation) -> str:
        return _urls.url_for(op, foreign_rows)

    return build


@pytest.fixture
def missing_url_for():
    return _urls.missing_url_for
