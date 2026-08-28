"""Factories for every model the tests touch (census row A7).

Synthetic values only — no name, address or email that resolves to a real
person (S8). Hand-built objects per test are the largest source of slow, brittle
suites; every factory here is written once for every test that follows.
"""
from __future__ import annotations

from itertools import count
from typing import Any

from django.contrib.auth import get_user_model

from apps.deepsearch.models import SearchRun
from apps.documents.models import Document
from apps.extensions.models import Extension, ExtensionInstall
from apps.fleet.models import FleetEvent, FleetLane, FleetRun

SYNTHETIC_DOMAIN = "phoenix.test"
SYNTHETIC_PASSWORD = "Sweep-Fixture-2026!xQ"

_seq = count(1)


def unique(prefix: str) -> str:
    return f"{prefix}-{next(_seq)}"


def make_user(**overrides: Any):
    email = overrides.pop("email", f"{unique('sweep')}@{SYNTHETIC_DOMAIN}")
    return get_user_model().objects.create_user(
        email=email, password=SYNTHETIC_PASSWORD, **overrides
    )


def make_document(owner=None, **overrides: Any) -> Document:
    title = overrides.pop("title", unique("Document"))
    return Document.objects.create(
        owner=owner,
        title=title,
        source_path=overrides.pop("source_path", f"/{title}.md"),
        **overrides,
    )


def make_search_run(owner=None, **overrides: Any) -> SearchRun:
    return SearchRun.objects.create(
        owner=owner, query=overrides.pop("query", unique("query")), **overrides
    )


def make_extension(**overrides: Any) -> Extension:
    slug = overrides.pop("slug", unique("extension"))
    return Extension.objects.create(
        slug=slug,
        name=overrides.pop("name", slug.replace("-", " ").title()),
        publisher=overrides.pop("publisher", "Synthetic Publisher"),
        category=overrides.pop("category", Extension.CATEGORY_CHOICES[0][0]),
        description=overrides.pop("description", "A synthetic catalog row."),
        **overrides,
    )


def make_install(extension: Extension, user, **overrides: Any) -> ExtensionInstall:
    return ExtensionInstall.objects.create(extension=extension, user=user, **overrides)


def make_fleet_run(owner=None, **overrides: Any) -> FleetRun:
    return FleetRun.objects.create(
        owner=owner, prompt=overrides.pop("prompt", unique("prompt")), **overrides
    )


def make_fleet_lane(run: FleetRun, **overrides: Any) -> FleetLane:
    agent = overrides.pop("agent", unique("agent"))
    return FleetLane.objects.create(
        run=run,
        agent=agent,
        worktree_path=overrides.pop("worktree_path", f"wt-{agent}"),
        **overrides,
    )


def make_fleet_event(run: FleetRun, **overrides: Any) -> FleetEvent:
    return FleetEvent.objects.create(
        run=run,
        at=overrides.pop("at", "00:00"),
        actor=overrides.pop("actor", unique("actor")),
        text=overrides.pop("text", "synthetic event"),
        **overrides,
    )


FACTORY_FOR_MODEL: dict[type, Any] = {
    get_user_model(): make_user,
    Document: make_document,
    SearchRun: make_search_run,
    Extension: make_extension,
    ExtensionInstall: make_install,
    FleetRun: make_fleet_run,
    FleetLane: make_fleet_lane,
    FleetEvent: make_fleet_event,
}
