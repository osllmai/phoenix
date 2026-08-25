import pytest
from ninja.testing import TestClient

from apps.documents.api import router
from apps.documents.models import Document
from apps.documents.tasks import convert_document

pytestmark = pytest.mark.django_db


@pytest.fixture
def client(auth_headers):
    return TestClient(router, headers=auth_headers)


@pytest.fixture(autouse=True)
def eager_celery(settings):
    settings.CELERY_TASK_ALWAYS_EAGER = True
    settings.CELERY_TASK_EAGER_PROPAGATES = True


def test_model_str_and_defaults():
    doc = Document.objects.create(title='Spec', source_path='/x/spec.md')
    assert doc.status == 'pending'
    assert str(doc) == 'Spec (pending)'


def test_list_endpoint(client, user):
    Document.objects.create(owner=user, title='A', source_path='/a.md')
    Document.objects.create(owner=user, title='B', source_path='/b.md')
    resp = client.get('/')
    assert resp.status_code == 200
    body = resp.json()
    assert len(body) == 2
    assert set(body[0].keys()) == {'id', 'title', 'status', 'created_at'}


def test_detail_endpoint(client, user):
    doc = Document.objects.create(owner=user, title='D', source_path='/d.md', markdown='# hi')
    resp = client.get(f'/{doc.id}/')
    assert resp.status_code == 200
    assert resp.json()['markdown'] == '# hi'


def test_detail_404(client):
    assert client.get('/9999/').status_code == 404


def test_create_endpoint(client, tmp_path, settings):
    settings.DOCUMENTS_ROOT = str(tmp_path)
    (tmp_path / 'note.md').write_text('# Title\nbody')
    resp = client.post('/', json={'title': 'Note', 'source_path': 'note.md'})
    assert resp.status_code == 200
    body = resp.json()
    assert body['title'] == 'Note'
    assert body['job_id']
    doc = Document.objects.get(pk=body['id'])
    assert doc.status == 'ready'
    assert doc.markdown == '# Title\nbody'


def test_delete_endpoint(client, user):
    doc = Document.objects.create(owner=user, title='Del', source_path='/del.md')
    resp = client.delete(f'/{doc.id}/')
    assert resp.status_code == 200
    assert not Document.objects.filter(pk=doc.id).exists()


def test_delete_404(client):
    assert client.delete('/9999/').status_code == 404


def test_convert_task_happy(tmp_path, settings):
    settings.DOCUMENTS_ROOT = str(tmp_path)
    (tmp_path / 'doc.txt').write_text('plain text')
    doc = Document.objects.create(title='T', source_path='doc.txt')
    convert_document(doc.id)
    doc.refresh_from_db()
    assert doc.status == 'ready'
    assert doc.markdown == 'plain text'
    assert doc.error == ''


def test_convert_task_placeholder(tmp_path, settings):
    settings.DOCUMENTS_ROOT = str(tmp_path)
    (tmp_path / 'doc.pdf').write_bytes(b'%PDF-1.4')
    doc = Document.objects.create(title='P', source_path='doc.pdf')
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


def test_create_rejects_oversized_fields(client):
    resp = client.post('/', json={'title': 'x' * 300, 'source_path': 'y' * 2000})
    assert resp.status_code == 422


def test_convert_refuses_absolute_path_outside_documents_root(tmp_path, settings, user):
    root = tmp_path / 'corpus'
    root.mkdir()
    settings.DOCUMENTS_ROOT = str(root)
    secret = tmp_path / 'secret.md'
    secret.write_text('classified')

    doc = Document.objects.create(owner=user, title='esc', source_path=str(secret))
    convert_document(doc.id)
    doc.refresh_from_db()
    assert doc.status == 'failed'
    assert 'classified' not in doc.markdown


def test_convert_refuses_dotdot_escape(tmp_path, settings, user):
    root = tmp_path / 'corpus'
    root.mkdir()
    settings.DOCUMENTS_ROOT = str(root)
    (tmp_path / 'secret.md').write_text('classified')

    doc = Document.objects.create(owner=user, title='esc2', source_path='../secret.md')
    convert_document(doc.id)
    doc.refresh_from_db()
    assert doc.status == 'failed'
    assert 'classified' not in doc.markdown


def test_convert_reads_inside_documents_root(tmp_path, settings, user):
    settings.DOCUMENTS_ROOT = str(tmp_path)
    (tmp_path / 'ok.md').write_text('# inside')
    doc = Document.objects.create(owner=user, title='ok', source_path='ok.md')
    convert_document(doc.id)
    doc.refresh_from_db()
    assert doc.status == 'ready'
    assert doc.markdown == '# inside'
