"""Real-lane helpers — resolve the live stack, and FAIL CLOSED on production.

A `real` test that can reach production is a BLOCKER, so the target is read from
the environment and rejected unless it resolves to a local stack host.
"""
from __future__ import annotations

import json
import os
from typing import Any
from urllib.error import HTTPError
from urllib.parse import urlparse
from urllib.request import Request, urlopen

import pytest

STACK_URL_ENV = "PHOENIX_REAL_STACK_URL"
PRODUCTION_MARKERS = ("prod", "production", "live", "nemati.ai")
LOCAL_HOSTS = frozenset({"localhost", "127.0.0.1", "0.0.0.0", "django", "backend", "phoenix"})
REQUEST_TIMEOUT_SECONDS = 10
SKIP_REASON = (
    f"DECLARED SKIP — {STACK_URL_ENV} is unset, so the real lane has no stack to drive. Set it "
    "to the local API base (host port from rules/ports.md band 37000) and re-run with -m real."
)


def resolve_stack_url() -> str:
    url = os.environ.get(STACK_URL_ENV)
    if not url:
        pytest.skip(reason=SKIP_REASON)

    if any(marker in url.lower() for marker in PRODUCTION_MARKERS):
        pytest.fail(f"BLOCKER — the real lane refuses to run against {url!r}")

    host = (urlparse(url).hostname or "").lower()
    if host not in LOCAL_HOSTS:
        pytest.fail(
            f"{STACK_URL_ENV}={url!r} does not resolve to a local stack host; the real lane "
            "fails closed rather than guessing"
        )
    return url.rstrip("/")


def fetch(url: str, headers: dict[str, str] | None = None):
    try:
        return urlopen(Request(url, headers=headers or {}), timeout=REQUEST_TIMEOUT_SECONDS)
    except TimeoutError as exc:
        pytest.fail(f"{url} timed out after {REQUEST_TIMEOUT_SECONDS}s: {exc}")


def status_of(url: str, headers: dict[str, str] | None = None) -> int:
    try:
        return fetch(url, headers).status
    except HTTPError as exc:
        return exc.code


def json_of(url: str, headers: dict[str, str] | None = None) -> Any:
    return json.loads(fetch(url, headers).read())


def assert_refuses_anonymous(url: str) -> None:
    status = status_of(url)
    assert status in (401, 403), (
        f"the live stack answered {status} for an anonymous request to {url}"
    )
