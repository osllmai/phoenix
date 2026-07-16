"""Concurrency control group: the extensions counter must not lose updates.

install_extension increments via an F() expression, so N parallel installs must
land N. This is the harness's own sanity check — if it fails, the threads (not
the code under test) are wrong.
"""
import threading
from concurrent.futures import ThreadPoolExecutor

import pytest
from django import db
from ninja.testing import TestClient

from apps.extensions.api import router
from apps.extensions.models import Extension

pytestmark = pytest.mark.django_db(transaction=True)

CALLS = 12


@pytest.fixture
def client():
    return TestClient(router)


@pytest.fixture
def ext():
    return Extension.objects.create(
        slug='race-doc', name='Race Doc', publisher='Tester',
        category='document', description='Convert PDFs to markdown.', icon='📄',
    )


def _call(client, barrier, path):
    try:
        barrier.wait(timeout=10)
        return client.post(path).status_code
    finally:
        db.connection.close()


def _race(client, paths):
    barrier = threading.Barrier(len(paths))
    with ThreadPoolExecutor(max_workers=len(paths)) as pool:
        futures = [pool.submit(_call, client, barrier, path) for path in paths]
        return [f.result() for f in futures]


def test_concurrent_installs_do_not_lose_updates(client, ext):
    statuses = _race(client, [f'/{ext.slug}/install/'] * CALLS)
    assert set(statuses) == {200}

    ext.refresh_from_db()
    assert ext.installs_count == CALLS, (
        f'lost update: {CALLS} installs but installs_count={ext.installs_count}'
    )
    assert ext.installed is True


def test_concurrent_uninstalls_are_idempotent(client, ext):
    Extension.objects.filter(pk=ext.pk).update(installed=True, installs_count=5)

    statuses = _race(client, [f'/{ext.slug}/uninstall/'] * CALLS)
    assert set(statuses) == {200}

    ext.refresh_from_db()
    assert ext.installed is False
    assert ext.installs_count == 5


def test_interleaved_install_uninstall_preserves_counter(client, ext):
    paths = [
        f'/{ext.slug}/install/' if i % 2 == 0 else f'/{ext.slug}/uninstall/'
        for i in range(CALLS)
    ]
    statuses = _race(client, paths)
    assert set(statuses) == {200}

    ext.refresh_from_db()
    installs = sum(1 for p in paths if p.endswith('/install/'))
    assert ext.installs_count == installs, (
        f'uninstall clobbered the counter: expected {installs}, '
        f'got {ext.installs_count}'
    )
    assert ext.installed in (True, False)
