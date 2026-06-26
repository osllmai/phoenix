import pytest

from config.celery import app


@pytest.fixture(autouse=True)
def _eager_celery():
    """Run the fan-out task inline so endpoint tests need no broker."""
    app.conf.task_always_eager = True
    app.conf.task_eager_propagates = True
    yield
    app.conf.task_always_eager = False
