"""The project's own OpenAPI document, and the two helpers that read it.

Built in-process via the ninja API object, so every sweep that consumes it needs
no running server.
"""
from __future__ import annotations

from typing import Any

from config.api import api

JSON_CONTENT_TYPE = "application/json"


def openapi_document() -> dict[str, Any]:
    return dict(api.get_openapi_schema())


def resolve_ref(schema: dict[str, Any] | None, document: dict[str, Any]) -> dict | None:
    """Follow a local `$ref` into the document's component schemas."""
    if not schema:
        return None
    ref = schema.get("$ref")
    if not ref:
        return schema
    node: Any = document
    for part in ref.lstrip("#/").split("/"):
        node = node.get(part, {})
    return node or None


def body_schema(operation: dict[str, Any], document: dict[str, Any]) -> dict | None:
    body = operation.get("requestBody")
    if not body:
        return None
    schema = body.get("content", {}).get(JSON_CONTENT_TYPE, {}).get("schema")
    return resolve_ref(schema, document) if schema else None
