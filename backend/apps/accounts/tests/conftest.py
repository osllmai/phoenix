from __future__ import annotations

from importlib import import_module

import pytest
from django.conf import settings
from django.contrib.auth import (
    BACKEND_SESSION_KEY,
    HASH_SESSION_KEY,
    SESSION_KEY,
    get_user_model,
)
from ninja.testing import TestClient

from apps.accounts.api import router

User = get_user_model()


def session_token_for(user) -> str:
    """Mint an allauth X-Session-Token (= authenticated session key) for `user`."""
    engine = import_module(settings.SESSION_ENGINE)
    store = engine.SessionStore()
    store[SESSION_KEY] = str(user.pk)
    store[BACKEND_SESSION_KEY] = "django.contrib.auth.backends.ModelBackend"
    store[HASH_SESSION_KEY] = user.get_session_auth_hash()
    store.save()
    return store.session_key


@pytest.fixture
def client() -> TestClient:
    return TestClient(router)


@pytest.fixture
def user(db):
    return User.objects.create_user(email="me@phoenix.test", password="Ph0enix-Test-2026!xQ")


@pytest.fixture
def token(user) -> str:
    return session_token_for(user)
