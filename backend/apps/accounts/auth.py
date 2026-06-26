"""ninja auth via allauth headless X-Session-Token.

Returns the authenticated User as `request.auth` (and sets `request.user`).
allauth owns the token/session lifecycle; soft-deleted users (`is_active=False`)
are rejected by `authenticate_by_x_session_token`.
"""
from __future__ import annotations

from allauth.headless.contrib.ninja.security import XSessionTokenAuth

from .models import User


class SessionTokenAuth(XSessionTokenAuth):
    def __call__(self, request) -> User | None:
        user = super().__call__(request)
        if user is not None:
            request.user = user
        return user


session_token_auth = SessionTokenAuth()
