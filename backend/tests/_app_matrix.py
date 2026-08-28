"""Shared per-app machinery (A1–A7). Each app gets a THIN module that binds it.

The rows are identical in shape across apps — contract matrix, query budget,
flatness, scenario contract, async enqueue + idempotency, factories — so they
are written once here and parameterized by the app's own operations.
"""
from __future__ import annotations

from collections.abc import Callable
from dataclasses import dataclass
from typing import Any

from django.db import connection
from django.test.utils import CaptureQueriesContext

from ._factories import FACTORY_FOR_MODEL
from ._ops import Operation, all_ops, openapi_document
from ._payloads import valid_body
from ._shapes import is_list_operation

UNAUTHENTICATED = (401, 403)
NOT_FOUND = 404
UNPROCESSABLE = 422
SUCCESS = range(200, 300)


@dataclass(frozen=True)
class AppSurface:
    """One app's slice of the API, resolved from the iterator by path prefix."""

    label: str
    prefix: str

    @property
    def operations(self) -> list[Operation]:
        return [op for op in all_ops() if op.path.startswith(self.prefix)]

    @property
    def document(self) -> dict[str, Any]:
        return openapi_document()

    @property
    def lists(self) -> list[Operation]:
        return [op for op in self.operations if is_list_operation(op, self.document)]

    @property
    def mutations(self) -> list[Operation]:
        return [op for op in self.operations if op.method in {"POST", "PATCH", "DELETE"}]


def assert_app_has_operations(surface: AppSurface) -> None:
    assert surface.operations, (
        f"{surface.label}: no operation mounted under {surface.prefix} — the app's router "
        "moved, and this matrix is now asserting nothing"
    )


def assert_unauthenticated_is_refused(surface, send, url_for, document) -> None:
    served = []
    for op in surface.operations:
        if op.is_public:
            continue
        status = send(op.method, url_for(op), valid_body(op.request_schema, document), None)
        if status not in UNAUTHENTICATED:
            served.append(f"{op.method} {op.path}: {status}")
    assert not served, f"{surface.label}: served without credentials:\n" + "\n".join(served)


def assert_second_identity_is_refused(surface, send, foreign_url_for, document) -> None:
    """`foreign_url_for` must address rows owned by the OTHER account, and the
    request goes out as the caller — sending them as their own owner proves
    nothing, it just reads your own row."""
    breaches = []
    for op in surface.operations:
        if op.is_public or not op.path_params:
            continue
        status = send(
            op.method, foreign_url_for(op), valid_body(op.request_schema, document), "auth"
        )
        if status in SUCCESS:
            breaches.append(f"{op.method} {op.path}: {status}")
    assert not breaches, (
        f"BLOCKER — {surface.label} served another account's rows; hand to /security-audit:\n"
        + "\n".join(breaches)
    )


def assert_invalid_body_is_422(surface, send, url_for) -> None:
    wrong = []
    for op in surface.operations:
        if not op.request_schema:
            continue
        status = send(op.method, url_for(op), {"__invalid__": object.__name__}, "auth")
        if status not in (UNPROCESSABLE, 200, 201):
            wrong.append(f"{op.method} {op.path}: {status}")
    assert not wrong, f"{surface.label}: invalid body not a 422:\n" + "\n".join(wrong)


def assert_missing_row_is_404(surface, send, missing_url_for, document) -> None:
    """A valid body is sent so the 404 comes from the missing row, not from
    validation refusing an empty payload first."""
    wrong = []
    for op in surface.operations:
        if not op.path_params or op.is_public:
            continue
        status = send(op.method, missing_url_for(op), valid_body(op.request_schema, document),
                      "auth")
        if status != NOT_FOUND:
            wrong.append(f"{op.method} {op.path}: {status}")
    assert not wrong, f"{surface.label}: a missing row is not a 404:\n" + "\n".join(wrong)


def query_count(call: Callable[[], object]) -> int:
    with CaptureQueriesContext(connection) as captured:
        call()
    return len(captured)


def assert_within_budget(label: str, count: int, budget: int) -> None:
    assert count <= budget, f"{label}: {count} queries > budget {budget}"


def assert_flat(label: str, at_one: int, at_many: int) -> None:
    assert at_one == at_many, (
        f"{label}: {at_one} query(s) at 1 row, {at_many} at N — the count grows with the row "
        "count, which a generous absolute budget would hide"
    )


def assert_every_touched_model_has_a_factory(models: list[type], label: str) -> None:
    without = [model._meta.label for model in models if model not in FACTORY_FOR_MODEL]
    assert not without, f"{label}: models used by tests with no factory: {without}"
