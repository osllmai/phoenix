"""django-allauth headless auth — env-backed URLs/email; no hand-rolled identity."""
from __future__ import annotations

import environ

env = environ.Env()

ACCOUNT_LOGIN_METHODS = {"email"}
ACCOUNT_SIGNUP_FIELDS = ["email*", "password1*", "password2*"]
ACCOUNT_EMAIL_VERIFICATION = "mandatory"
ACCOUNT_PREVENT_ENUMERATION = True
ACCOUNT_UNIQUE_EMAIL = True
ACCOUNT_REAUTHENTICATION_REQUIRED = True
ACCOUNT_USER_MODEL_USERNAME_FIELD = None
ACCOUNT_USER_MODEL_EMAIL_FIELD = "email"

MFA_SUPPORTED_TYPES = ["totp", "recovery_codes"]
MFA_TOTP_DIGITS = 6
MFA_TOTP_PERIOD = 30
MFA_RECOVERY_CODE_COUNT = 10

HEADLESS_ONLY = True
HEADLESS_FRONTEND_URLS = {
    "account_confirm_email": env("HEADLESS_URL_CONFIRM_EMAIL"),
    "account_reset_password_from_key": env("HEADLESS_URL_RESET_PASSWORD"),
    "account_signup": env("HEADLESS_URL_SIGNUP"),
}

EMAIL_BACKEND = env("EMAIL_BACKEND")
DEFAULT_FROM_EMAIL = env("DEFAULT_FROM_EMAIL")
