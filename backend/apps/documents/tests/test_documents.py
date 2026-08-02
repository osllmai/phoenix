import pytest
from ninja.testing import TestClient

from apps.documents.api import router
from apps.documents.models import Document
from apps.documents.tasks import convert_document

pytestmark = pytest.mark.django_db


@pytest.fixture
def client():
    return TestClient(router)


@pytest.fixture(autouse=True)
def eager_celery(settings):
    settings.CELERY_TASK_ALWAYS_EAGER = True
    settings.CELERY_TASK_EAGER_PROPAGATES = True


def test_model_str_and_defaults():
    doc = Document.objects.create(title='Spec', source_path='/x/spec.md')
    assert doc.status == 'pending'
    assert str(doc) == 'Spec (pending)'


def test_list_endpoint(client):
    Document.objects.create(title='A', source_path='/a.md')
    Document.objects.create(title='B', source_path='/b.md')
    resp = client.get('/')
    assert resp.status_code == 200
    body = resp.json()
    assert len(body) == 2
    assert set(body[0].keys()) == {'id', 'title', 'status', 'created_at'}


def test_detail_endpoint(client):
    doc = Document.objects.create(title='D', source_path='/d.md', markdown='# hi')
    resp = client.get(f'/{doc.id}/')
    assert resp.status_code == 200
    assert resp.json()['markdown'] == '# hi'


def test_detail_404(client):
    assert client.get('/9999/').status_code == 404


def test_create_endpoint(client, tmp_path):
    src = tmp_path / 'note.md'
    src.write_text('# Title\nbody')
    resp = client.post('/', json={'title': 'Note', 'source_path': str(src)})
    assert resp.status_code == 200
    body = resp.json()
    assert body['title'] == 'Note'
    assert body['job_id']
    doc = Document.objects.get(pk=body['id'])
    assert doc.status == 'ready'
    assert doc.markdown == '# Title\nbody'


def test_delete_endpoint(client):
    doc = Document.objects.create(title='Del', source_path='/del.md')
    resp = client.delete(f'/{doc.id}/')
    assert resp.status_code == 200
    assert not Document.objects.filter(pk=doc.id).exists()


def test_delete_404(client):
    assert client.delete('/9999/').status_code == 404


def test_convert_task_happy(tmp_path):
    src = tmp_path / 'doc.txt'
    src.write_text('plain text')
    doc = Document.objects.create(title='T', source_path=str(src))
    convert_document(doc.id)
    doc.refresh_from_db()
    assert doc.status == 'ready'
    assert doc.markdown == 'plain text'
    assert doc.error == ''


def test_convert_task_placeholder(tmp_path):
    src = tmp_path / 'doc.pdf'
    src.write_bytes(b'%PDF-1.4')
    doc = Document.objects.create(title='P', source_path=str(src))
    convert_document(doc.id)
    doc.refresh_from_db()
    assert doc.status == 'ready'
    assert 'Docling' in doc.markdown


def test_convert_task_missing_file():
    doc = Document.objects.create(title='Missing', source_path='/nope/missing.pdf')
    result = convert_document(doc.id)
    doc.refresh_from_db()
    assert result['status'] == 'failed'
    assert doc.status == 'failed'
    assert 'missing.pdf' in doc.error
