from __future__ import annotations

import pytest
from ninja.testing import TestClient

from apps.accounts.api import router


@pytest.fixture
def client() -> TestClient:
    return TestClient(router)
