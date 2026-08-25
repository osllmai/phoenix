"""ai_chat — per-app matrix rows A1–A7.

This app carries no model and no task of its own: it fires the shared DeepSearch
job and exposes the /jobs/<id>/ polling contract. The matrix asserts exactly
that delegation, and that it never grows a second retrieval implementation.
"""
from __future__ import annotations

import pytest
from django.test import Client

from apps.deepsearch.models import SearchRun
from tests import _factories as f
from tests._app_matrix import (
    AppSurface,
    assert_app_has_operations,
    assert_every_touched_model_has_a_factory,
    assert_invalid_body_is_422,
    assert_unauthenticated_is_refused,
    assert_within_budget,
    query_count,
)
from tests._thresholds import DETAIL_QUERY_BUDGET
from tests._urls import NULL_UUID, send, status_of, url_for

pytestmark = [pytest.mark.django_db, pytest.mark.mock]

SURFACE = AppSurface(label="ai_chat", prefix="/api/v1/ai-chat/")
DEEP_SEARCH_URL = "/api/v1/ai-chat/deep-search/"
JOB_URL = f"/api/v1/ai-chat/jobs/{NULL_UUID}/"


@pytest.fixture(autouse=True)
def eager(settings) -> None:
    settings.CELERY_TASK_ALWAYS_EAGER = True
    settings.CELERY_TASK_EAGER_PROPAGATES = True


@pytest.fixture
def http() -> Client:
    return Client()


@pytest.fixture
def rows(db):
    return {"extension": f.make_extension()}


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


def test_a1_an_invalid_body_is_422(dispatch, rows):
    assert_invalid_body_is_422(SURFACE, dispatch, lambda op: url_for(op, rows))


def test_a1_an_unknown_job_id_polls_without_a_5xx(http, auth_headers):
    """AsyncResult answers PENDING for an id it has never seen — that is the
    documented contract, not a 404, so this asserts the shape it does return."""
    response = send(http, "GET", JOB_URL, None, auth_headers)

    assert response.status_code == 200
    body = response.json()
    assert body["job_id"] == NULL_UUID
    assert body["status"] == body["status"].lower()


def test_a1_a_deep_search_creates_a_run_owned_by_the_caller(http, auth_headers, user):
    body = send(http, "POST", DEEP_SEARCH_URL, {"query": "vectors"}, auth_headers).json()

    run = SearchRun.objects.get(pk=body["run_id"])
    assert run.owner == user
    assert body["status"] == "queued" and body["job_id"]


def test_a1_a_second_identity_never_reaches_the_first_ones_run(
    http, auth_headers, other_headers, other_user
):
    body = send(http, "POST", DEEP_SEARCH_URL, {"query": "vectors"}, auth_headers).json()
    detail = send(
        http, "GET", f"/api/v1/deepsearch/{body['run_id']}/", None, other_headers
    )

    assert detail.status_code == 404


def test_a2_the_job_poll_stays_within_its_query_budget(http, auth_headers):
    count = query_count(lambda: send(http, "GET", JOB_URL, None, auth_headers))
    assert_within_budget("ai_chat.job_poll", count, DETAIL_QUERY_BUDGET)


def test_a3_the_delegated_retrieval_cost_does_not_grow_with_the_corpus(
    http, auth_headers, user
):
    f.make_document(owner=user, title="Vectors")
    at_one = query_count(
        lambda: send(http, "POST", DEEP_SEARCH_URL, {"query": "vectors"}, auth_headers)
    )

    for _ in range(5):
        f.make_document(owner=user, title="Vectors")
    at_many = query_count(
        lambda: send(http, "POST", DEEP_SEARCH_URL, {"query": "vectors"}, auth_headers)
    )

    assert at_one == at_many, (
        f"retrieval cost grew from {at_one} to {at_many} queries with the corpus size"
    )


@pytest.mark.scenario("03-django-celery-hybrid.md")
def test_a5_the_endpoint_delegates_rather_than_running_retrieval_inline(
    http, auth_headers, user
):
    f.make_document(owner=user, title="Vectors", markdown="vector search rocks")
    body = send(http, "POST", DEEP_SEARCH_URL, {"query": "vector"}, auth_headers).json()

    run = SearchRun.objects.get(pk=body["run_id"])
    assert run.status == "ready", "the shared DeepSearch job must actually run"
    assert run.sources and run.sources[0]["title"] == "Vectors"


def test_a5_this_app_owns_no_model_of_its_own():
    """The delegation contract, asserted — a model appearing here means a second
    retrieval implementation is being grown."""
    from django.apps import apps as django_apps

    assert not list(django_apps.get_app_config("ai_chat").get_models()), (
        "ai_chat has grown its own models; retrieval belongs in apps.deepsearch"
    )


def test_a7_every_model_this_app_touches_has_a_factory():
    assert_every_touched_model_has_a_factory([SearchRun], "ai_chat")
