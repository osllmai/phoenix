"""Concurrency control group: install state is per-account, so the counter must
track install ROWS, not calls.

N parallel installs from one account are one install — get_or_create collapses
them and only the winner increments. The invariant every test here asserts is
`installs_count == ExtensionInstall.objects.filter(extension=ext).count()`.
"""
import threading
from concurrent.futures import ThreadPoolExecutor

import pytest
from django import db
from ninja.testing import TestClient

from apps.extensions.api import router
from apps.extensions.models import Extension, ExtensionInstall

pytestmark = pytest.mark.django_db(transaction=True)

CALLS = 12


@pytest.fixture
def client(auth_headers):
    return TestClient(router, headers=auth_headers)


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


def _install_rows(ext):
    return ExtensionInstall.objects.filter(extension=ext).count()


def test_concurrent_installs_from_one_account_collapse_to_one(client, ext):
    statuses = _race(client, [f'/{ext.slug}/install/'] * CALLS)
    assert set(statuses) == {200}

    ext.refresh_from_db()
    assert _install_rows(ext) == 1, 'the unique constraint must collapse the race'
    assert ext.installs_count == _install_rows(ext), (
        f'counter drifted: installs_count={ext.installs_count}, rows={_install_rows(ext)}'
    )


def test_concurrent_uninstalls_decrement_exactly_once(client, ext, user):
    ExtensionInstall.objects.create(extension=ext, user=user)
    Extension.objects.filter(pk=ext.pk).update(installs_count=5)

    statuses = _race(client, [f'/{ext.slug}/uninstall/'] * CALLS)
    assert set(statuses) == {200}

    ext.refresh_from_db()
    assert _install_rows(ext) == 0
    assert ext.installs_count == 4, (
        f'{CALLS} concurrent uninstalls decremented more than once: {ext.installs_count}'
    )


def test_interleaved_install_uninstall_keeps_counter_equal_to_rows(client, ext):
    paths = [
        f'/{ext.slug}/install/' if i % 2 == 0 else f'/{ext.slug}/uninstall/'
        for i in range(CALLS)
    ]
    statuses = _race(client, paths)
    assert set(statuses) == {200}

    ext.refresh_from_db()
    assert ext.installs_count == _install_rows(ext), (
        f'counter drifted from reality: installs_count={ext.installs_count}, '
        f'rows={_install_rows(ext)}'
    )
