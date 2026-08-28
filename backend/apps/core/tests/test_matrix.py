"""core — per-app matrix rows A1–A7.

core mounts no router and owns no model: it is the home of the cross-cutting
contract sweeps (test_response_contract.py, test_ownership_isolation.py). So its
matrix asserts that shape holds, rather than inventing endpoints to test.
"""
from __future__ import annotations

from pathlib import Path

import pytest
from django.apps import apps as django_apps

from tests._app_matrix import AppSurface
from tests._thresholds import BACKEND_DIR

pytestmark = pytest.mark.mock

SURFACE = AppSurface(label="core", prefix="/api/v1/core/")
CORE_TESTS = BACKEND_DIR / "apps" / "core" / "tests"

#: The cross-cutting sweeps core owns. Losing one is losing a whole tier.
OWNED_SWEEPS = (
    "test_response_contract.py",
    "test_ownership_isolation.py",
    "contract_cases.py",
)


def test_a1_core_mounts_no_router_of_its_own():
    assert not SURFACE.operations, (
        f"core now mounts operations ({[op.path for op in SURFACE.operations]}) — give it a real "
        "contract matrix instead of this absence assert"
    )


def test_a1_core_owns_no_model():
    assert not list(django_apps.get_app_config("core").get_models()), (
        "core has grown models; cross-cutting code owns no data"
    )


def test_a4_the_cross_cutting_sweeps_core_owns_are_all_present():
    missing = [name for name in OWNED_SWEEPS if not (CORE_TESTS / name).exists()]
    assert not missing, f"core's cross-cutting sweeps are missing: {missing}"


def test_a4_the_response_contract_still_reads_the_router_mechanically():
    """contract_cases builds its route table from api._routers. A hardcoded list
    would rot the week it lands, so the mechanism itself is asserted."""
    source = (CORE_TESTS / "contract_cases.py").read_text(encoding="utf-8")
    assert "api._routers" in source, (
        "contract_cases no longer derives its routes from the router — the sweep has become a "
        "hand-maintained list"
    )


def test_a4_no_backend_scenario_doc_names_core_without_a_test():
    """design/scenario/apps/core/ documents the pure-Dart phoenix_core SDK, not
    this Django app — recorded so the roster gap is attributed correctly."""
    scenarios = BACKEND_DIR.parent / "design" / "scenario" / "apps" / "core"
    if not scenarios.is_dir():
        pytest.skip("DECLARED SKIP — design/ is outside the backend Docker build context")

    docs = sorted(path.name for path in scenarios.glob("*.md"))
    assert docs, "design/scenario/apps/core/ is empty; the attribution below is stale"
    assert "engine-contracts.md" in docs, (
        "the core scenario docs changed shape; re-check whether they now describe the Django "
        "app rather than packages/phoenix_core (owner: /e2e flutter)"
    )


def test_a5_core_enqueues_no_job():
    tasks = Path(BACKEND_DIR / "apps" / "core" / "tasks.py")
    assert not tasks.exists(), "core now defines Celery tasks; give it the async + idempotency rows"


def test_a7_core_needs_no_factory_because_it_owns_no_model():
    assert not list(django_apps.get_app_config("core").get_models())
