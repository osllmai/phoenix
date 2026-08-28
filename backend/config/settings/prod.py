"""Production settings — DEBUG off, behind nginx/TLS. Inherits base."""
from django.core.exceptions import ImproperlyConfigured

from .base import *  # noqa: F403

DEBUG = False
ALLOWED_HOSTS = env.list('PROD_ALLOWED_HOSTS', default=[])  # noqa: F405
if not ALLOWED_HOSTS or '*' in ALLOWED_HOSTS:
    raise ImproperlyConfigured('PROD_ALLOWED_HOSTS must be set to explicit hosts (no wildcard)')

# Trust nginx's forwarded proto so Django knows requests are HTTPS.
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
CSRF_TRUSTED_ORIGINS = env.list('CSRF_TRUSTED_ORIGINS', default=[])  # noqa: F405

SECURE_HSTS_SECONDS = env.int('SECURE_HSTS_SECONDS', default=31536000)  # noqa: F405
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True
SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SESSION_COOKIE_HTTPONLY = True
SECURE_CONTENT_TYPE_NOSNIFF = True
SECURE_REFERRER_POLICY = 'same-origin'
