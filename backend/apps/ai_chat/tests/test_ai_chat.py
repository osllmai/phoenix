"""ai_chat delegates to the real DeepSearch job — it carries no retrieval of its own."""
import pytest
from ninja.testing import TestClient

from apps.ai_chat.api import router
from apps.deepsearch.models import SearchRun
from apps.documents.models import Document

pytestmark = pytest.mark.django_db


@pytest.fixture
def client(auth_headers):
    return TestClient(router, headers=auth_headers)


@pytest.fixture(autouse=True)
def eager_celery(settings):
    settings.CELERY_TASK_ALWAYS_EAGER = True
    settings.CELERY_TASK_EAGER_PROPAGATES = True


def test_deep_search_creates_a_run_owned_by_the_caller(client, user):
    resp = client.post('/deep-search/', json={'query': 'vectors'})
    assert resp.status_code == 200

    body = resp.json()
    assert body['status'] == 'queued'
    run = SearchRun.objects.get(pk=body['run_id'])
    assert run.owner == user
    assert run.query == 'vectors'


def test_deep_search_runs_the_real_retrieval(client, user):
    Document.objects.create(
        owner=user, title='Vectors', source_path='/v.md', markdown='vector search rocks'
    )
    body = client.post('/deep-search/', json={'query': 'vector'}).json()

    run = SearchRun.objects.get(pk=body['run_id'])
    assert run.status == 'ready', 'the job must actually run, not return not_implemented'
    assert run.sources, 'retrieval must find the matching document'
    assert run.sources[0]['title'] == 'Vectors'


def test_deep_search_only_searches_the_callers_documents(client, other_user):
    Document.objects.create(
        owner=other_user, title='Secret', source_path='/s.md', markdown='vector secrets'
    )
    body = client.post('/deep-search/', json={'query': 'vector'}).json()

    run = SearchRun.objects.get(pk=body['run_id'])
    assert run.sources == [], "another account's documents must never appear in results"


def test_deep_search_requires_auth():
    assert TestClient(router).post('/deep-search/', json={'query': 'x'}).status_code == 401


def test_job_status_polls_celery(client):
    body = client.post('/deep-search/', json={'query': 'vectors'}).json()
    resp = client.get(f"/jobs/{body['job_id']}/")
    assert resp.status_code == 200
    assert resp.json()['job_id'] == body['job_id']


def test_deep_search_rejects_oversized_query(client):
    assert client.post('/deep-search/', json={'query': 'q' * 2000}).status_code == 422


def test_job_status_survives_unreachable_result_backend(client, monkeypatch):
    def boom(*a, **k):
        raise ConnectionError('broker down')

    monkeypatch.setattr('celery.result.AsyncResult', boom)
    resp = client.get('/jobs/some-job-id/')
    assert resp.status_code == 200
    assert resp.json()['status'] == 'unknown'
