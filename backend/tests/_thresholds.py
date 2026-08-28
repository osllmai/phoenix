"""Every numeric gate the sweeps assert against, named once.

A budget written inline is a budget nobody can find when it needs to change, so
no sweep in this package carries a bare literal — it imports a name from here.
"""
from __future__ import annotations

from pathlib import Path

TESTS_DIR: Path = Path(__file__).resolve().parent
BACKEND_DIR: Path = TESTS_DIR.parent
REPO_ROOT: Path = BACKEND_DIR.parent
BASELINE_DIR: Path = TESTS_DIR / "baselines"

MAX_ITERATOR_SKIPS = 3

FLATNESS_ROW_COUNT = 7
MAX_SQL_FINGERPRINT_REPEATS = 3
LIST_QUERY_BUDGET = 12
DETAIL_QUERY_BUDGET = 12
MUTATION_QUERY_BUDGET = 24

MAX_LIST_ROWS_RETURNED = 500
PAGINATION_ROW_COUNT = 9
RESPONSE_BYTE_BUDGET = 256 * 1024

OVERSIZED_BODY_BYTES = 4 * 1024 * 1024
OVERSIZED_STRING_LENGTH = 200_000

SCHEMATHESIS_EXAMPLES_PER_PR = 25
SCHEMATHESIS_EXAMPLES_NIGHTLY = 200

QUARANTINE_MAX_AGE_DAYS = 14
#: One: schemathesis is not in requirements.txt (test_g36_schema_fuzz.py).
#: The real lane's stack-url skip lives in tests/_real.py, which this count does
#: not scan — it is a lane precondition, not a skipped assertion.
DECLARED_SKIP_COUNT = 1
MOCK_LANE_BUDGET_SECONDS = 120
REAL_LANE_BUDGET_SECONDS = 300

BENCHMARK_ROUNDS = 25
BENCHMARK_REGRESSION_RATIO = 1.5

CONCURRENT_WRITERS = 2
