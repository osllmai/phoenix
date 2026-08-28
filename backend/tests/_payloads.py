"""Synthesize request bodies from an operation's JSON Schema.

The sweeps drive every operation, so they need a body per operation. Deriving it
from the schema keeps them correct when a field is added; a hand-written payload
table would silently stop matching the contract it is meant to exercise.
"""
from __future__ import annotations

from typing import Any

from ._ops import resolve_ref
from ._thresholds import OVERSIZED_STRING_LENGTH

SAFE_TEXT = "sweep"
SAFE_INT = 1
SAFE_NUMBER = 1.0


def _leaf(schema: dict[str, Any], name: str) -> Any:
    kind = schema.get("type")
    if schema.get("enum"):
        return schema["enum"][0]
    if kind == "integer":
        return SAFE_INT
    if kind == "number":
        return SAFE_NUMBER
    if kind == "boolean":
        return True
    if kind == "array":
        return [SAFE_TEXT]
    if kind == "object":
        return {}
    return f"{SAFE_TEXT}-{name}"


def _unwrap(schema: dict[str, Any], document: dict[str, Any]) -> dict[str, Any]:
    for key in ("anyOf", "oneOf", "allOf"):
        if key in schema:
            branches = [resolve_ref(b, document) or {} for b in schema[key]]
            concrete = [b for b in branches if b.get("type") != "null"]
            return concrete[0] if concrete else {}
    return schema


def valid_body(schema: dict[str, Any] | None, document: dict[str, Any]) -> dict | None:
    """A minimal body satisfying every required field of `schema`."""
    if not schema or schema.get("type") != "object":
        return None
    properties = schema.get("properties", {})
    required = schema.get("required", list(properties))
    body: dict[str, Any] = {}
    for name in required:
        prop = _unwrap(resolve_ref(properties.get(name, {}), document) or {}, document)
        body[name] = _leaf(prop, name)
    return body


def wrong_typed_body(schema: dict[str, Any] | None, document: dict[str, Any]) -> dict | None:
    """The same body with every value replaced by a value of the wrong type."""
    body = valid_body(schema, document)
    if body is None:
        return None
    return {name: ([] if isinstance(value, str) else "x") for name, value in body.items()}


def oversized_body(schema: dict[str, Any] | None, document: dict[str, Any]) -> dict | None:
    body = valid_body(schema, document)
    if body is None:
        return None
    return dict.fromkeys(body, SAFE_TEXT * OVERSIZED_STRING_LENGTH)


def protected_field_probe() -> dict[str, Any]:
    """Fields a client must never be able to set (BOPLA-write / G30)."""
    return {
        "id": 999_999,
        "is_staff": True,
        "is_superuser": True,
        "owner": 999_999,
        "owner_id": 999_999,
        "user_id": 999_999,
        "role": "admin",
        "balance": 1_000_000,
        "installs_count": 999_999,
        "is_winner": True,
        "created_at": "1999-01-01T00:00:00Z",
        "date_joined": "1999-01-01T00:00:00Z",
        "deleted_at": None,
    }
