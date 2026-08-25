"""ninja auth via allauth headless X-Session-Token.

Returns the authenticated User as `request.auth` (and sets `request.user`).
allauth owns the token/session lifecycle; soft-deleted users (`is_active=False`)
are rejected by `authenticate_by_x_session_token`.
"""
from __future__ import annotations

from allauth.headless.contrib.ninja.security import XSessionTokenAuth
from django.contrib.auth.models import AnonymousUser

from .models import User


class SessionTokenAuth(XSessionTokenAuth):
    openapi_in = 'header'
    openapi_name = 'X-Session-Token'

    def __call__(self, request) -> User | None:
        user = super().__call__(request)
        if user is not None:
            request.user = user
        return user


class OptionalSessionTokenAuth(SessionTokenAuth):
    """For public routes that still personalize their response. A valid token
    yields the user; no token yields AnonymousUser instead of a 401."""

    def __call__(self, request):
        return super().__call__(request) or AnonymousUser()


session_token_auth = SessionTokenAuth()
optional_session_token_auth = OptionalSessionTokenAuth()
