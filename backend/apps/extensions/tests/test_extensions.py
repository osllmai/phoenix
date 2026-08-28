import pytest
from ninja.testing import TestClient

from apps.extensions.api import router
from apps.extensions.models import Extension, ExtensionInstall

pytestmark = pytest.mark.django_db


@pytest.fixture
def client(auth_headers):
    return TestClient(router, headers=auth_headers)


@pytest.fixture
def ext():
    return Extension.objects.create(
        slug='test-doc', name='Test Doc', publisher='Tester',
        category='document', description='Convert PDFs to markdown.', icon='📄',
    )


def test_model_str_and_defaults(ext):
    assert ext.version == '1.0.0'
    assert ext.verified is False
    assert ext.installs_count == 0
    assert str(ext) == 'Test Doc (document)'


def test_list_endpoint(client, ext):
    resp = client.get('/')
    assert resp.status_code == 200
    body = resp.json()
    slugs = {row['slug'] for row in body}
    assert 'test-doc' in slugs
    assert {'id', 'slug', 'name', 'category', 'installed'} <= set(body[0].keys())


def test_list_category_filter(client, ext):
    resp = client.get('/?category=speech')
    assert resp.status_code == 200
    slugs = {row['slug'] for row in resp.json()}
    assert 'test-doc' not in slugs
    assert all(row['category'] == 'speech' for row in resp.json())


def test_list_q_filter(client, ext):
    resp = client.get('/?q=Test Doc')
    assert resp.status_code == 200
    slugs = {row['slug'] for row in resp.json()}
    assert slugs == {'test-doc'}


def test_detail_endpoint(client, ext):
    resp = client.get(f'/{ext.slug}/')
    assert resp.status_code == 200
    assert resp.json()['description'] == 'Convert PDFs to markdown.'


def test_detail_404(client):
    assert client.get('/nope/').status_code == 404


def test_install_endpoint(client, ext, user):
    resp = client.post(f'/{ext.slug}/install/')
    assert resp.status_code == 200
    body = resp.json()
    assert body['installed'] is True
    assert body['installs_count'] == 1
    ext.refresh_from_db()
    assert ext.installs_count == 1
    assert ExtensionInstall.objects.filter(extension=ext, user=user).exists()


def test_install_404(client):
    assert client.post('/nope/install/').status_code == 404


def test_uninstall_endpoint(client, ext, user):
    ExtensionInstall.objects.create(extension=ext, user=user)
    ext.installs_count = 5
    ext.save()
    resp = client.post(f'/{ext.slug}/uninstall/')
    assert resp.status_code == 200
    body = resp.json()
    assert body['installed'] is False
    assert body['installs_count'] == 4
    ext.refresh_from_db()
    assert not ExtensionInstall.objects.filter(extension=ext, user=user).exists()


def test_uninstall_404(client):
    assert client.post('/nope/uninstall/').status_code == 404


def test_seed_migration_populated_catalog():
    """0002 seed migration runs on the test DB; one extension per category."""
    cats = set(Extension.objects.values_list('category', flat=True))
    assert {'document', 'speech', 'search', 'developer', 'evaluator', 'flows'} <= cats
    assert Extension.objects.count() >= 6
