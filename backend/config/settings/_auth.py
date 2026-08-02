"""django-allauth (headless) configuration — the canonical auth/users core.

Imported by `config/settings/base.py`. Identity lives in our own Postgres
(allauth owns hashing/sessions/verify/reset/MFA — none hand-rolled, no paid SaaS).
Transport is allauth headless via the `X-Session-Token` header; the ninja surface
uses `x_session_token_auth`.
"""
from __future__ import annotations

import environ

env = environ.Env()

# ── Account ──────────────────────────────────────────────────────────────────
ACCOUNT_LOGIN_METHODS = {"email"}
ACCOUNT_SIGNUP_FIELDS = ["email*", "password1*", "password2*"]
ACCOUNT_EMAIL_VERIFICATION = "mandatory"
ACCOUNT_PREVENT_ENUMERATION = True
ACCOUNT_UNIQUE_EMAIL = True
ACCOUNT_REAUTHENTICATION_REQUIRED = True
# accounts.User is email-only (no username field).
ACCOUNT_USER_MODEL_USERNAME_FIELD = None
ACCOUNT_USER_MODEL_EMAIL_FIELD = "email"

# ── MFA — TOTP + recovery codes (portfolio-wide) ─────────────────────────────
MFA_SUPPORTED_TYPES = ["totp", "recovery_codes"]
MFA_TOTP_DIGITS = 6
MFA_TOTP_PERIOD = 30
MFA_RECOVERY_CODE_COUNT = 10

# ── Headless ─────────────────────────────────────────────────────────────────
HEADLESS_ONLY = True
HEADLESS_FRONTEND_URLS = {
    "account_confirm_email": env(
        "HEADLESS_URL_CONFIRM_EMAIL", default="https://app.phoenix.local/account/verify-email/{key}"
    ),
    "account_reset_password_from_key": env(
        "HEADLESS_URL_RESET_PASSWORD", default="https://app.phoenix.local/account/password/reset/{key}"
    ),
    "account_signup": env("HEADLESS_URL_SIGNUP", default="https://app.phoenix.local/account/signup"),
}

# ── Email ────────────────────────────────────────────────────────────────────
# Mandatory verification needs an email backend; dev/test default to console so
# the verification code is readable from logs. Prod sets SMTP via env.
EMAIL_BACKEND = env("EMAIL_BACKEND", default="django.core.mail.backends.console.EmailBackend")
DEFAULT_FROM_EMAIL = env("DEFAULT_FROM_EMAIL", default="no-reply@phoenix.local")
