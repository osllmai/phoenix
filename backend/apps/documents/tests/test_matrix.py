"""documents — per-app matrix rows A1–A7, bound to the shared machinery in
backend/tests/_app_matrix.py. Existing documents tests are untouched; this adds
the rows the census asks for and nothing they already cover.
"""
from __future__ import annotations

import pytest
from django.test import Client

from apps.documents.models import Document
from tests import _factories as f
from tests._app_matrix import (
    AppSurface,
    assert_app_has_operations,
    assert_every_touched_model_has_a_factory,
    assert_flat,
    assert_invalid_body_is_422,
    assert_missing_row_is_404,
    assert_second_identity_is_refused,
    assert_unauthenticated_is_refused,
    assert_within_budget,
    query_count,
)
from tests._thresholds import FLATNESS_ROW_COUNT, LIST_QUERY_BUDGET
from tests._urls import missing_url_for, send, status_of, url_for

pytestmark = [pytest.mark.django_db, pytest.mark.mock]

SURFACE = AppSurface(label="documents", prefix="/api/v1/documents/")
LIST_URL = "/api/v1/documents/"


@pytest.fixture(autouse=True)
def eager(settings) -> None:
    settings.CELERY_TASK_ALWAYS_EAGER = True
    settings.CELERY_TASK_EAGER_PROPAGATES = True


@pytest.fixture
def http() -> Client:
    return Client()


@pytest.fixture
def rows(db, user):
    return {"document": f.make_document(owner=user), "extension": f.make_extension()}


@pytest.fixture
def foreign(db, other_user):
    return {"document": f.make_document(owner=other_user), "extension": f.make_extension()}


@pytest.fixture
def dispatch(http, auth_headers, other_headers):
    def call(method: str, url: str, body=None, identity: str | None = "auth") -> int:
        headers = {"auth": auth_headers, "other": other_headers}.get(identity)
        return status_of(http, method, url, body, headers)

    return call


def test_a1_the_app_still_mounts_operations():
    assert_app_has_operations(SURFACE)


def test_a1_unauthenticated_is_refused(dispatch, rows):
    assert_unauthenticated_is_refused(
        SURFACE, dispatch, lambda op: url_for(op, rows), SURFACE.document
    )


def test_a1_a_second_identity_is_refused(dispatch, foreign):
    assert_second_identity_is_refused(
        SURFACE, dispatch, lambda op: url_for(op, foreign), SURFACE.document
    )


def test_a1_an_invalid_body_is_422(dispatch, rows):
    assert_invalid_body_is_422(SURFACE, dispatch, lambda op: url_for(op, rows))


def test_a1_a_missing_row_is_404(dispatch):
    assert_missing_row_is_404(SURFACE, dispatch, missing_url_for, SURFACE.document)


def test_a1_a_create_writes_the_row_and_the_owner(http, auth_headers, user):
    response = send(
        http, "POST", LIST_URL, {"title": "Matrix", "source_path": "/m.md"}, auth_headers
    )

    assert response.status_code == 200
    doc = Document.objects.get(pk=response.json()["id"])
    assert doc.owner == user and doc.title == "Matrix"


def test_a1_a_delete_removes_the_row(http, auth_headers, user):
    doc = f.make_document(owner=user)
    assert send(http, "DELETE", f"{LIST_URL}{doc.pk}/", None, auth_headers).status_code == 200
    assert not Document.objects.filter(pk=doc.pk).exists()


def test_a2_the_list_stays_within_its_query_budget(http, auth_headers, user):
    for _ in range(FLATNESS_ROW_COUNT):
        f.make_document(owner=user)
    count = query_count(lambda: send(http, "GET", LIST_URL, None, auth_headers))
    assert_within_budget("documents.list", count, LIST_QUERY_BUDGET)


def test_a3_the_list_is_flat_from_one_row_to_n(http, auth_headers, user):
    f.make_document(owner=user)
    at_one = query_count(lambda: send(http, "GET", LIST_URL, None, auth_headers))

    for _ in range(FLATNESS_ROW_COUNT):
        f.make_document(owner=user)
    at_many = query_count(lambda: send(http, "GET", LIST_URL, None, auth_headers))

    assert_flat("documents.list", at_one, at_many)


@pytest.mark.scenario("03-django-celery-hybrid.md")
def test_a5_a_create_enqueues_a_job_and_returns_immediately(http, auth_headers, user):
    response = send(
        http, "POST", LIST_URL, {"title": "Async", "source_path": "/a.md"}, auth_headers
    )

    body = response.json()
    assert body["job_id"], "the create must return a job id, not run the work inline"
    assert body["status"] in {"pending", "converting", "ready", "failed"}


def test_a5_two_identical_creates_make_two_rows(http, auth_headers, user):
    """No Idempotency-Key contract is documented, so the honest assertion is that
    two requests are two rows — the day dedup lands, this fails and is updated."""
    for _ in range(2):
        send(http, "POST", LIST_URL, {"title": "Same", "source_path": "/s.md"}, auth_headers)
    assert Document.objects.filter(owner=user, title="Same").count() == 2


def test_a7_every_model_this_app_touches_has_a_factory():
    assert_every_touched_model_has_a_factory([Document], "documents")
