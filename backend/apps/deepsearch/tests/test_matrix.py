"""deepsearch — per-app matrix rows A1–A7."""
from __future__ import annotations

import pytest
from django.test import Client

from apps.deepsearch.models import SearchRun
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

SURFACE = AppSurface(label="deepsearch", prefix="/api/v1/deepsearch/")
LIST_URL = "/api/v1/deepsearch/"


@pytest.fixture(autouse=True)
def eager(settings) -> None:
    settings.CELERY_TASK_ALWAYS_EAGER = True
    settings.CELERY_TASK_EAGER_PROPAGATES = True


@pytest.fixture
def http() -> Client:
    return Client()


@pytest.fixture
def rows(db, user):
    return {"search": f.make_search_run(owner=user), "extension": f.make_extension()}


@pytest.fixture
def foreign(db, other_user):
    return {"search": f.make_search_run(owner=other_user), "extension": f.make_extension()}


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


def test_a1_a_start_writes_the_run_owned_by_the_caller(http, auth_headers, user):
    response = send(http, "POST", LIST_URL, {"query": "vectors"}, auth_headers)

    assert response.status_code == 200
    run = SearchRun.objects.get(pk=response.json()["id"])
    assert run.owner == user and run.query == "vectors"


def test_a2_the_list_stays_within_its_query_budget(http, auth_headers, user):
    for _ in range(FLATNESS_ROW_COUNT):
        f.make_search_run(owner=user)
    count = query_count(lambda: send(http, "GET", LIST_URL, None, auth_headers))
    assert_within_budget("deepsearch.list", count, LIST_QUERY_BUDGET)


def test_a3_the_list_is_flat_from_one_row_to_n(http, auth_headers, user):
    f.make_search_run(owner=user)
    at_one = query_count(lambda: send(http, "GET", LIST_URL, None, auth_headers))

    for _ in range(FLATNESS_ROW_COUNT):
        f.make_search_run(owner=user)
    at_many = query_count(lambda: send(http, "GET", LIST_URL, None, auth_headers))

    assert_flat("deepsearch.list", at_one, at_many)


@pytest.mark.scenario("03-django-celery-hybrid.md")
def test_a5_a_start_enqueues_a_job_and_returns_a_job_id(http, auth_headers, user):
    body = send(http, "POST", LIST_URL, {"query": "vectors"}, auth_headers).json()

    assert body["job_id"], "the start must return a job id rather than run inline"
    assert SearchRun.objects.get(pk=body["id"]).status in {"pending", "running", "ready", "failed"}


def test_a5_a_retrieval_failure_records_the_error_rather_than_raising(
    http, auth_headers, user, monkeypatch
):
    monkeypatch.setattr(
        "apps.deepsearch.tasks._retrieve",
        lambda *args, **kwargs: (_ for _ in ()).throw(RuntimeError("index gone")),
    )
    body = send(http, "POST", LIST_URL, {"query": "x"}, auth_headers).json()

    run = SearchRun.objects.get(pk=body["id"])
    assert run.status == "failed" and run.error == "index gone"


def test_a5_replaying_the_same_query_creates_two_runs(http, auth_headers, user):
    for _ in range(2):
        send(http, "POST", LIST_URL, {"query": "same"}, auth_headers)
    assert SearchRun.objects.filter(owner=user, query="same").count() == 2


def test_a7_every_model_this_app_touches_has_a_factory():
    assert_every_touched_model_has_a_factory([SearchRun], "deepsearch")
