"""Ensure the Celery app loads with Django."""
from .celery import app as celery_app

__all__ = ('celery_app',)
