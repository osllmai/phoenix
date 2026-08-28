"""One user must never reach another user's rows (IDOR guard).

Every owned collection is checked the same way: user A creates a row, then user
B must not see it in a list, fetch it, or mutate it. Unowned rows are checked
too — the owner column is nullable, so `owner IS NULL` must reach nobody.
"""
import pytest
from django.test import Client

from apps.deepsearch.models import SearchRun
from apps.documents.models import Document
from apps.extensions.models import Extension
from apps.fleet.models import FleetRun

pytestmark = pytest.mark.django_db


@pytest.fixture(autouse=True)
def eager_celery(settings):
    settings.CELERY_TASK_ALWAYS_EAGER = True
    settings.CELERY_TASK_EAGER_PROPAGATES = True


@pytest.fixture
def client():
    return Client()


def _post(client, url, payload, headers):
    return client.post(url, data=payload, content_type='application/json', headers=headers)


def _make_document(client, headers):
    return _post(
        client, '/api/v1/documents/', {'title': 'A', 'source_path': '/a.md'}, headers
    ).json()


def _make_search(client, headers):
    return _post(client, '/api/v1/deepsearch/', {'query': 'vectors'}, headers).json()


def _make_run(client, headers):
    return _post(
        client, '/api/v1/fleet/runs/', {'prompt': 'ship it', 'agents': ['claude-code']}, headers
    ).json()


def test_created_rows_belong_to_the_caller(client, auth_headers, user):
    doc = _make_document(client, auth_headers)
    search = _make_search(client, auth_headers)
    run = _make_run(client, auth_headers)

    assert Document.objects.get(pk=doc['id']).owner == user
    assert SearchRun.objects.get(pk=search['id']).owner == user
    assert FleetRun.objects.get(pk=run['id']).owner == user


def test_documents_are_invisible_to_another_user(client, auth_headers, other_headers):
    doc_id = _make_document(client, auth_headers)['id']

    assert client.get('/api/v1/documents/', headers=other_headers).json() == []
    assert client.get(f'/api/v1/documents/{doc_id}/', headers=other_headers).status_code == 404
    assert client.delete(f'/api/v1/documents/{doc_id}/', headers=other_headers).status_code == 404
    assert Document.objects.filter(pk=doc_id).exists()


def test_searches_are_invisible_to_another_user(client, auth_headers, other_headers):
    run_id = _make_search(client, auth_headers)['id']

    assert client.get('/api/v1/deepsearch/', headers=other_headers).json() == []
    assert client.get(f'/api/v1/deepsearch/{run_id}/', headers=other_headers).status_code == 404


def test_fleet_runs_are_invisible_to_another_user(client, auth_headers, other_headers):
    run = _make_run(client, auth_headers)
    run_id, lane_id = run['id'], run['lanes'][0]['id']

    assert client.get('/api/v1/fleet/runs/', headers=other_headers).json() == []
    assert client.get(f'/api/v1/fleet/runs/{run_id}/', headers=other_headers).status_code == 404

    merge = _post(
        client, f'/api/v1/fleet/runs/{run_id}/merge/', {'lane_id': lane_id}, other_headers
    )
    assert merge.status_code == 404
    assert FleetRun.objects.get(pk=run_id).status != 'merged'


def test_owner_still_reaches_its_own_rows(client, auth_headers):
    doc_id = _make_document(client, auth_headers)['id']
    run_id = _make_run(client, auth_headers)['id']

    assert client.get(f'/api/v1/documents/{doc_id}/', headers=auth_headers).status_code == 200
    assert client.get(f'/api/v1/fleet/runs/{run_id}/', headers=auth_headers).status_code == 200
    assert len(client.get('/api/v1/documents/', headers=auth_headers).json()) == 1


def test_extension_install_is_per_account(client, auth_headers, other_headers):
    """The catalog row is shared; the install state on it is not."""
    ext = Extension.objects.create(
        slug='shared-cat', name='Shared', publisher='Tester', category='document',
    )
    assert _post(client, f'/api/v1/extensions/{ext.slug}/install/', {}, auth_headers).json()[
        'installed'
    ] is True

    mine = client.get(f'/api/v1/extensions/{ext.slug}/', headers=auth_headers).json()
    theirs = client.get(f'/api/v1/extensions/{ext.slug}/', headers=other_headers).json()
    anon = client.get(f'/api/v1/extensions/{ext.slug}/').json()

    assert mine['installed'] is True
    assert theirs['installed'] is False, 'one account installing must not install for another'
    assert anon['installed'] is False, 'anonymous browse must never report installed'
    assert mine['installs_count'] == theirs['installs_count'] == 1


def test_unowned_rows_reach_nobody(client, auth_headers, other_headers):
    """The owner column is nullable; a row with no owner must be fail-closed."""
    Document.objects.create(title='orphan', source_path='/orphan.md')
    SearchRun.objects.create(query='orphan')
    FleetRun.objects.create(prompt='orphan')

    for headers in (auth_headers, other_headers):
        assert client.get('/api/v1/documents/', headers=headers).json() == []
        assert client.get('/api/v1/deepsearch/', headers=headers).json() == []
        assert client.get('/api/v1/fleet/runs/', headers=headers).json() == []
