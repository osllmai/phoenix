"""Local/dev settings — inherits env-backed values from base."""
from .base import *  # noqa: F403

DEBUG = True
ALLOWED_HOSTS = ['*']
