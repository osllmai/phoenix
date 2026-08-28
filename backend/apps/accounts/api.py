"""Compact accounts surface — the ONLY hand-written auth routes.

Identity flows (signup/login/logout/verify/reset/MFA) come from allauth headless
at /_allauth/app/v1/...; these stay minimal:

    GET    /accounts/me/
    PATCH  /accounts/me/
    DELETE /accounts/me/        — GDPR account deletion (soft-delete)
    POST   /accounts/me/export/ — GDPR data export
"""
from __future__ import annotations

from django.http import HttpRequest
from ninja import Router

from .auth import session_token_auth
from .schemas import UserMeRead, UserMeWrite

router = Router(tags=["accounts"], auth=session_token_auth)


@router.get("/me/", response=UserMeRead)
def get_me(request: HttpRequest):
    return request.auth


@router.patch("/me/", response=UserMeRead)
def patch_me(request: HttpRequest, payload: UserMeWrite):
    user = request.auth
    for field, value in payload.dict(exclude_unset=True).items():
        if value is not None:
            setattr(user, field, value)
    user.save()
    return user


@router.delete("/me/")
def delete_me(request: HttpRequest):
    """GDPR account deletion — soft-delete; the token stops authenticating."""
    request.auth.soft_delete()
    return {"status": "deleted"}


@router.post("/me/export/")
def export_me(request: HttpRequest):
    """GDPR data export — the personal data this app owns."""
    u = request.auth
    return {
        "user": {
            "id": str(u.id),
            "email": u.email,
            "full_name": u.full_name,
            "locale": u.locale,
            "date_joined": u.date_joined.isoformat() if u.date_joined else None,
        }
    }
