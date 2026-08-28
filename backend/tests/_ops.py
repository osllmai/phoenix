"""The ONE operation iterator every global sweep consumes.

Derived from the project's own OpenAPI document plus Django's URL resolver —
never a hardcoded route list, so an operation added tomorrow is swept tomorrow.
Four copies of an operation loop is a defect; this is the single copy.
"""
from __future__ import annotations

import re
from collections.abc import Iterator
from dataclasses import dataclass, field
from typing import Any

from django.urls import URLResolver, get_resolver

from config.api import api

from ._schema import body_schema, openapi_document, resolve_ref  # noqa: F401
from ._thresholds import MAX_ITERATOR_SKIPS

PATH_PARAM = re.compile(r"\{([^}]+)\}")

#: Operations the sweeps must not drive, each with the reason as data.
#: A growing list is how a sweep quietly stops sweeping — MAX_ITERATOR_SKIPS caps it.
SKIPS: dict[tuple[str, str], str] = {
    ("DELETE", "/api/v1/accounts/me/"): (
        "soft-deletes the calling account; every later operation in the same "
        "sweep would then run without a valid session"
    ),
}


@dataclass(frozen=True)
class Operation:
    """One mounted API operation, as the sweeps need it."""

    method: str
    path: str
    operation_id: str
    auth_required: bool
    auth_optional: bool
    request_schema: dict[str, Any] | None
    responses: dict[str, Any] = field(default_factory=dict)
    parameters: tuple[str, ...] = ()

    @property
    def path_params(self) -> tuple[str, ...]:
        return tuple(PATH_PARAM.findall(self.path))

    @property
    def is_public(self) -> bool:
        return not self.auth_required or self.auth_optional

    def fill(self, values: dict[str, Any]) -> str:
        """Concrete URL for this operation, params taken from `values`."""
        url = self.path
        for name in self.path_params:
            if name not in values:
                raise KeyError(f"no sample value supplied for path param {name!r}")
            url = url.replace("{" + name + "}", str(values[name]))
        return url


def api_prefix() -> str:
    """Where the ninja API is mounted, read from the resolver, never assumed."""
    for pattern in get_resolver().url_patterns:
        if isinstance(pattern, URLResolver) and pattern.app_name == "ninja":
            return "/" + str(pattern.pattern)
    raise RuntimeError("the ninja API is not mounted in ROOT_URLCONF")


def _absolute(path: str, prefix: str) -> str:
    if path.startswith(prefix):
        return path
    return prefix.rstrip("/") + "/" + path.lstrip("/")


def _optional_auth_paths() -> set[tuple[str, str]]:
    """Operations whose auth yields AnonymousUser rather than a 401."""
    from apps.accounts.auth import OptionalSessionTokenAuth

    prefix = api_prefix().rstrip("/")
    out: set[tuple[str, str]] = set()
    for router_prefix, router in api._routers:
        for path, view in router.path_operations.items():
            template = f"{prefix}{router_prefix.rstrip('/')}{path}"
            for op in view.operations:
                callbacks = getattr(op, "auth_callbacks", []) or []
                if any(isinstance(cb, OptionalSessionTokenAuth) for cb in callbacks):
                    out.update((method, template) for method in op.methods)
    return out


def operations(include_skipped: bool = False) -> Iterator[Operation]:
    document = openapi_document()
    prefix = api_prefix()
    optional = _optional_auth_paths()

    for raw_path, methods in document.get("paths", {}).items():
        path = _absolute(raw_path, prefix)
        for method, operation in methods.items():
            verb = method.upper()
            if not include_skipped and (verb, path) in SKIPS:
                continue
            yield Operation(
                method=verb,
                path=path,
                operation_id=operation.get("operationId", f"{verb} {path}"),
                auth_required=bool(operation.get("security")),
                auth_optional=(verb, path) in optional,
                request_schema=body_schema(operation, document),
                responses=operation.get("responses", {}),
                parameters=tuple(
                    p.get("name", "") for p in operation.get("parameters", [])
                    if p.get("in") == "query"
                ),
            )


def mounted_routes() -> set[tuple[str, str]]:
    """(method, path) actually mounted on the routers — the resolver's view."""
    prefix = api_prefix().rstrip("/")
    out: set[tuple[str, str]] = set()
    for router_prefix, router in api._routers:
        for path, view in router.path_operations.items():
            template = f"{prefix}{router_prefix.rstrip('/')}{path}"
            out.update((method, template) for op in view.operations for method in op.methods)
    return out


def all_ops() -> list[Operation]:
    return list(operations())


def skip_list_is_within_cap() -> tuple[bool, str]:
    """Asserted by test_g06_g07_routes.py — a growing skip list stops the sweep."""
    over = len(SKIPS) > MAX_ITERATOR_SKIPS
    unreasoned = [key for key, reason in SKIPS.items() if not reason.strip()]
    return (
        not over and not unreasoned,
        f"{len(SKIPS)} skips (cap {MAX_ITERATOR_SKIPS}); without a reason: {unreasoned}",
    )
