import pytest
from ninja.testing import TestClient

from apps.deepsearch.api import router
from apps.deepsearch.models import SearchRun
from apps.deepsearch.tasks import run_search
from apps.documents.models import Document

pytestmark = pytest.mark.django_db


@pytest.fixture
def client():
    return TestClient(router)


@pytest.fixture(autouse=True)
def eager_celery(settings):
    settings.CELERY_TASK_ALWAYS_EAGER = True
    settings.CELERY_TASK_EAGER_PROPAGATES = True


def test_model_str_and_defaults():
    run = SearchRun.objects.create(query='neural nets')
    assert run.status == 'pending'
    assert run.scope == 'local'
    assert run.depth == 'standard'
    assert run.sources == []
    assert str(run) == 'neural nets (pending)'


def test_start_endpoint(client):
    Document.objects.create(title='Vectors', source_path='/v.md', markdown='vector search rocks')
    resp = client.post('/', json={'query': 'vector'})
    assert resp.status_code == 200
    body = resp.json()
    assert body['job_id']
    assert body['id']
    run = SearchRun.objects.get(pk=body['id'])
    assert run.status == 'ready'


def test_start_endpoint_status_pending_without_eager(client, settings):
    settings.CELERY_TASK_ALWAYS_EAGER = False
    resp = client.post('/', json={'query': 'anything', 'scope': 'local', 'depth': 'deep'})
    body = resp.json()
    assert body['status'] == 'pending'
    assert body['job_id']


def test_detail_endpoint(client):
    run = SearchRun.objects.create(query='q', answer='a', sources=[{'title': 't'}])
    resp = client.get(f'/{run.id}/')
    assert resp.status_code == 200
    body = resp.json()
    assert body['answer'] == 'a'
    assert body['sources'] == [{'title': 't'}]


def test_detail_404(client):
    assert client.get('/9999/').status_code == 404


def test_list_endpoint(client):
    SearchRun.objects.create(query='one')
    SearchRun.objects.create(query='two')
    resp = client.get('/')
    assert resp.status_code == 200
    body = resp.json()
    assert len(body) == 2
    assert set(body[0].keys()) == {'id', 'query', 'status', 'created_at'}


def test_run_search_matches_and_excludes():
    hit = Document.objects.create(
        title='Transformers', source_path='/t.md',
        markdown='Transformers use attention. attention is all you need attention.',
    )
    miss = Document.objects.create(
        title='Cooking', source_path='/c.md', markdown='How to bake bread.',
    )
    run = SearchRun.objects.create(query='attention transformers', depth='quick')
    run_search(run.id)
    run.refresh_from_db()
    assert run.status == 'ready'
    assert run.sources
    ids = {s['document_id'] for s in run.sources}
    assert hit.id in ids
    assert miss.id not in ids
    assert run.sources[0]['relevance'] == 1.0
    assert 'attention' in run.answer.lower()


def test_run_search_no_match():
    Document.objects.create(title='Unrelated', source_path='/u.md', markdown='nothing here')
    run = SearchRun.objects.create(query='quantumchromodynamics')
    run_search(run.id)
    run.refresh_from_db()
    assert run.status == 'ready'
    assert run.sources == []
    assert 'No local sources' in run.answer


def test_run_search_empty_query():
    run = SearchRun.objects.create(query='   ')
    run_search(run.id)
    run.refresh_from_db()
    assert run.status == 'ready'
    assert run.sources == []


def test_run_search_depth_limits():
    for i in range(12):
        Document.objects.create(title=f'D{i}', source_path=f'/{i}.md', markdown='alpha alpha')
    run = SearchRun.objects.create(query='alpha', depth='deep')
    run_search(run.id)
    run.refresh_from_db()
    assert len(run.sources) == 8


def test_run_search_failure_path(monkeypatch):
    run = SearchRun.objects.create(query='boom')

    def explode(*args, **kwargs):
        raise RuntimeError('retrieval exploded')

    monkeypatch.setattr('apps.deepsearch.tasks._retrieve', explode)
    result = run_search(run.id)
    run.refresh_from_db()
    assert result['status'] == 'failed'
    assert run.status == 'failed'
    assert 'exploded' in run.error
