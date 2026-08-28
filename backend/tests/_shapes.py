"""Response-shape helpers read off the OpenAPI document.

Several rows need the same question answered — "is this operation a list?",
"which fields does it declare?" — so it is answered once here.
"""
from __future__ import annotations

from typing import Any

from ._ops import Operation, resolve_ref

JSON = "application/json"
OK = "200"


def response_schema(op: Operation, document: dict[str, Any]) -> dict | None:
    content = op.responses.get(OK, {}).get("content", {})
    schema = content.get(JSON, {}).get("schema")
    return resolve_ref(schema, document) if schema else None


def is_list_operation(op: Operation, document: dict[str, Any]) -> bool:
    if op.method != "GET":
        return False
    schema = response_schema(op, document)
    return bool(schema and schema.get("type") == "array")


def item_schema(op: Operation, document: dict[str, Any]) -> dict | None:
    schema = response_schema(op, document)
    if not schema:
        return None
    if schema.get("type") == "array":
        return resolve_ref(schema.get("items"), document)
    return schema


def declared_fields(op: Operation, document: dict[str, Any]) -> set[str]:
    schema = item_schema(op, document)
    return set((schema or {}).get("properties", {}))


def list_operations(ops: list[Operation], document: dict[str, Any]) -> list[Operation]:
    return [op for op in ops if is_list_operation(op, document)]


def mutating(ops: list[Operation]) -> list[Operation]:
    return [op for op in ops if op.method in {"POST", "PATCH", "PUT", "DELETE"}]


def with_body(ops: list[Operation]) -> list[Operation]:
    return [op for op in ops if op.request_schema]


def field_names_in(payload: Any) -> set[str]:
    """Every key appearing anywhere in a decoded JSON body."""
    found: set[str] = set()
    stack: list[Any] = [payload]
    while stack:
        node = stack.pop()
        if isinstance(node, dict):
            found.update(node)
            stack.extend(node.values())
        elif isinstance(node, list):
            stack.extend(node)
    return found
