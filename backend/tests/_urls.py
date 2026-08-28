"""URL building and request sending, shared by the global sweeps and the per-app
matrices so neither carries its own copy.
"""
from __future__ import annotations

from typing import Any

from django.test import Client

from ._ops import Operation

NULL_UUID = "00000000-0000-0000-0000-000000000000"
MISSING_ROW_ID = 10_000_019
MISSING_SLUG = "no-such-row"


def params_for(op: Operation, rows: dict[str, Any]) -> dict[str, Any]:
    """Sample path-param values for one operation.

    Keyed on the path, not the param name: `run_id` means a SearchRun under
    /deepsearch/ and a FleetRun under /fleet/, and a name-keyed table would
    quietly send the wrong id to one of them.
    """
    values: dict[str, Any] = {}
    for name in op.path_params:
        if name == "job_id":
            values[name] = NULL_UUID
        elif name == "slug":
            values[name] = rows["extension"].slug
        elif name == "document_id":
            values[name] = rows["document"].pk
        elif name == "run_id":
            values[name] = rows["fleet_run" if "/fleet/" in op.path else "search"].pk
        else:
            raise KeyError(f"the sweep has no sample value for path param {name!r}")
    return values


def missing_params_for(op: Operation) -> dict[str, Any]:
    """Ids that resolve to no row — the 404 half of the contract matrix."""
    return {
        name: (MISSING_SLUG if name == "slug" else
               NULL_UUID if name == "job_id" else MISSING_ROW_ID)
        for name in op.path_params
    }


def url_for(op: Operation, rows: dict[str, Any]) -> str:
    return op.fill(params_for(op, rows))


def missing_url_for(op: Operation) -> str:
    return op.fill(missing_params_for(op))


def send(client: Client, method: str, url: str, body: Any = None, headers=None):
    call = getattr(client, method.lower())
    if body is None:
        return call(url, headers=headers)
    return call(url, data=body, content_type="application/json", headers=headers)


def status_of(client: Client, method: str, url: str, body: Any = None, headers=None) -> int:
    return send(client, method, url, body, headers).status_code
