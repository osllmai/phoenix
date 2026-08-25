"""accounts — per-app matrix rows A1–A7.

Identity flows belong to allauth headless at /_allauth/; this app owns only the
compact /accounts/me/ surface, so the matrix covers exactly that.
"""
from __future__ import annotations

import pytest
from django.contrib.auth import get_user_model
from django.test import Client

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
from tests._urls import send, status_of, url_for

pytestmark = [pytest.mark.django_db, pytest.mark.mock]

SURFACE = AppSurface(label="accounts", prefix="/api/v1/accounts/")
ME_URL = "/api/v1/accounts/me/"
EXPORT_URL = "/api/v1/accounts/me/export/"


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


def test_a1_me_returns_the_calling_account_only(http, auth_headers, user, other_user):
    body = send(http, "GET", ME_URL, None, auth_headers).json()

    assert body["email"] == user.email
    assert body["id"] == str(user.pk)
    assert other_user.email not in str(body)


def test_a1_a_patch_persists_the_change(http, auth_headers, user):
    response = send(http, "PATCH", ME_URL, {"full_name": "Renamed", "locale": "de"}, auth_headers)

    assert response.status_code == 200
    user.refresh_from_db()
    assert user.full_name == "Renamed" and user.locale == "de"


def test_a1_a_patch_of_an_unknown_field_does_not_write_it(http, auth_headers, user):
    send(http, "PATCH", ME_URL, {"full_name": "Kept", "email": "hijack@phoenix.test"},
         auth_headers)

    user.refresh_from_db()
    assert user.full_name == "Kept"
    assert user.email != "hijack@phoenix.test", "email is not a client-writable field"


def test_a1_a_second_identity_never_sees_the_first_account(http, auth_headers, other_headers,
                                                           user, other_user):
    mine = send(http, "GET", ME_URL, None, auth_headers).json()
    theirs = send(http, "GET", ME_URL, None, other_headers).json()

    assert mine["id"] != theirs["id"]
    assert mine["email"] == user.email and theirs["email"] == other_user.email


def test_a2_the_me_read_stays_within_its_query_budget(http, auth_headers, user):
    count = query_count(lambda: send(http, "GET", ME_URL, None, auth_headers))
    assert_within_budget("accounts.me", count, DETAIL_QUERY_BUDGET)


def test_a3_the_export_cost_does_not_grow_with_the_accounts_rows(http, auth_headers, user):
    at_one = query_count(lambda: send(http, "POST", EXPORT_URL, None, auth_headers))

    for _ in range(5):
        f.make_document(owner=user)
    at_many = query_count(lambda: send(http, "POST", EXPORT_URL, None, auth_headers))

    assert at_one == at_many, (
        f"the export cost grew from {at_one} to {at_many} queries with the account's rows"
    )


def test_a5_this_app_enqueues_no_job():
    enqueueing = [op.path for op in SURFACE.operations if "job" in op.path.lower()]
    assert not enqueueing, f"accounts now enqueues work: {enqueueing}"


def test_a7_every_model_this_app_touches_has_a_factory():
    assert_every_touched_model_has_a_factory([get_user_model()], "accounts")
