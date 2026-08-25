"""fleet — per-app matrix rows A1–A7."""
from __future__ import annotations

import pytest
from django.test import Client

from apps.fleet.models import FleetEvent, FleetLane, FleetRun
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

SURFACE = AppSurface(label="fleet", prefix="/api/v1/fleet/")
LIST_URL = "/api/v1/fleet/runs/"
LANES_PER_RUN = 3


@pytest.fixture(autouse=True)
def eager(settings) -> None:
    settings.CELERY_TASK_ALWAYS_EAGER = True
    settings.CELERY_TASK_EAGER_PROPAGATES = True


@pytest.fixture
def http() -> Client:
    return Client()


@pytest.fixture
def rows(db, user):
    run = f.make_fleet_run(owner=user)
    f.make_fleet_lane(run)
    return {"fleet_run": run, "extension": f.make_extension()}


@pytest.fixture
def foreign(db, other_user):
    run = f.make_fleet_run(owner=other_user)
    f.make_fleet_lane(run)
    return {"fleet_run": run, "extension": f.make_extension()}


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


def test_a1_a_fan_out_creates_one_lane_per_agent(http, auth_headers, user):
    agents = ["claude-code", "cursor", "codex"]
    response = send(http, "POST", LIST_URL, {"prompt": "ship", "agents": agents}, auth_headers)

    assert response.status_code == 200
    run = FleetRun.objects.get(pk=response.json()["id"])
    assert run.owner == user
    assert list(run.lanes.values_list("agent", flat=True)) == agents


def test_a1_a_merge_marks_exactly_one_winner(http, auth_headers, user):
    run = f.make_fleet_run(owner=user)
    lane = f.make_fleet_lane(run)

    response = send(
        http, "POST", f"{LIST_URL}{run.pk}/merge/", {"lane_id": lane.pk}, auth_headers
    )

    assert response.status_code == 200
    run.refresh_from_db()
    assert run.status == "merged"
    assert FleetLane.objects.filter(run=run, is_winner=True).count() == 1


def test_a2_the_list_stays_within_its_query_budget(http, auth_headers, user):
    for _ in range(FLATNESS_ROW_COUNT):
        run = f.make_fleet_run(owner=user)
        for _lane in range(LANES_PER_RUN):
            f.make_fleet_lane(run)
    count = query_count(lambda: send(http, "GET", LIST_URL, None, auth_headers))
    assert_within_budget("fleet.runs.list", count, LIST_QUERY_BUDGET)


def test_a3_the_list_is_flat_from_one_row_to_n(http, auth_headers, user):
    """RunListOut resolves lane_count and done_count per row — the exact shape
    that grows one query per run unless it is annotated."""
    f.make_fleet_run(owner=user)
    at_one = query_count(lambda: send(http, "GET", LIST_URL, None, auth_headers))

    for _ in range(FLATNESS_ROW_COUNT):
        f.make_fleet_run(owner=user)
    at_many = query_count(lambda: send(http, "GET", LIST_URL, None, auth_headers))

    assert_flat("fleet.runs.list", at_one, at_many)


@pytest.mark.scenario("03-django-celery-hybrid.md")
def test_a5_a_fan_out_hands_off_to_the_runtime_asynchronously(http, auth_headers, user):
    response = send(
        http, "POST", LIST_URL, {"prompt": "ship", "agents": ["claude-code"]}, auth_headers
    )

    assert response.status_code == 200
    assert FleetRun.objects.get(pk=response.json()["id"]).status == "running"


def test_a7_every_model_this_app_touches_has_a_factory():
    assert_every_touched_model_has_a_factory([FleetRun, FleetLane, FleetEvent], "fleet")
