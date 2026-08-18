"""Production settings — DEBUG off, behind nginx/TLS. Inherits base."""
from .base import *  # noqa: F403

DEBUG = False
ALLOWED_HOSTS = env.list('ALLOWED_HOSTS', default=[])  # noqa: F405

# Trust nginx's forwarded proto so Django knows requests are HTTPS.
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
CSRF_TRUSTED_ORIGINS = env.list('CSRF_TRUSTED_ORIGINS', default=[])  # noqa: F405
