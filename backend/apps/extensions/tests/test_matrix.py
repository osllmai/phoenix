"""extensions — per-app matrix rows A1–A7.

The catalog is the one optional-auth surface: browsing is public, install state
is per account. Both halves are asserted here.
"""
from __future__ import annotations

import pytest
from django.test import Client

from apps.extensions.models import Extension, ExtensionInstall
from tests import _factories as f
from tests._app_matrix import (
    AppSurface,
    assert_app_has_operations,
    assert_every_touched_model_has_a_factory,
    assert_flat,
    assert_invalid_body_is_422,
    assert_unauthenticated_is_refused,
    assert_within_budget,
    query_count,
)
from tests._thresholds import FLATNESS_ROW_COUNT, LIST_QUERY_BUDGET
from tests._urls import MISSING_SLUG, send, status_of, url_for

pytestmark = [pytest.mark.django_db, pytest.mark.mock]

SURFACE = AppSurface(label="extensions", prefix="/api/v1/extensions/")
LIST_URL = "/api/v1/extensions/"


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


def test_a1_the_gated_operations_refuse_an_anonymous_caller(dispatch, rows):
    assert_unauthenticated_is_refused(
        SURFACE, dispatch, lambda op: url_for(op, rows), SURFACE.document
    )


def test_a1_the_catalog_is_readable_without_credentials(http, rows):
    for url in (LIST_URL, f"{LIST_URL}{rows['extension'].slug}/"):
        assert send(http, "GET", url).status_code == 200


def test_a1_an_invalid_body_is_422(dispatch, rows):
    assert_invalid_body_is_422(SURFACE, dispatch, lambda op: url_for(op, rows))


def test_a1_an_unknown_slug_is_404(http, auth_headers):
    for method, suffix in (("GET", ""), ("POST", "install/"), ("POST", "uninstall/")):
        url = f"{LIST_URL}{MISSING_SLUG}/{suffix}"
        assert send(http, method, url, {}, auth_headers).status_code == 404


def test_a1_install_state_is_per_account(http, auth_headers, other_headers, user, other_user):
    ext = f.make_extension()
    send(http, "POST", f"{LIST_URL}{ext.slug}/install/", {}, auth_headers)

    mine = send(http, "GET", f"{LIST_URL}{ext.slug}/", None, auth_headers).json()
    theirs = send(http, "GET", f"{LIST_URL}{ext.slug}/", None, other_headers).json()

    assert mine["installed"] is True and theirs["installed"] is False
    assert ExtensionInstall.objects.filter(extension=ext, user=user).exists()
    assert not ExtensionInstall.objects.filter(extension=ext, user=other_user).exists()


def test_a2_the_catalog_stays_within_its_query_budget(http, auth_headers, user):
    for _ in range(FLATNESS_ROW_COUNT):
        f.make_install(f.make_extension(), user)
    count = query_count(lambda: send(http, "GET", LIST_URL, None, auth_headers))
    assert_within_budget("extensions.catalog", count, LIST_QUERY_BUDGET)


def test_a3_the_catalog_is_flat_from_one_row_to_n(http, auth_headers, user):
    """The `installed` annotation is an Exists subquery — flat by construction,
    and this is what proves it stays that way."""
    f.make_install(f.make_extension(), user)
    at_one = query_count(lambda: send(http, "GET", LIST_URL, None, auth_headers))

    for _ in range(FLATNESS_ROW_COUNT):
        f.make_install(f.make_extension(), user)
    at_many = query_count(lambda: send(http, "GET", LIST_URL, None, auth_headers))

    assert_flat("extensions.catalog", at_one, at_many)


def test_a3_the_anonymous_catalog_is_also_flat(http, db):
    f.make_extension()
    at_one = query_count(lambda: send(http, "GET", LIST_URL))

    for _ in range(FLATNESS_ROW_COUNT):
        f.make_extension()
    at_many = query_count(lambda: send(http, "GET", LIST_URL))

    assert_flat("extensions.catalog.anonymous", at_one, at_many)


def test_a5_this_app_enqueues_no_job():
    """Absence-assert: the catalog is synchronous, so an enqueue appearing here
    later needs the async + idempotency rows written."""
    enqueueing = [op.path for op in SURFACE.operations if "job" in op.path.lower()]
    assert not enqueueing, f"extensions now enqueues work: {enqueueing}"


def test_a7_every_model_this_app_touches_has_a_factory():
    assert_every_touched_model_has_a_factory([Extension, ExtensionInstall], "extensions")
