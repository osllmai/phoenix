"""Documents router. CRUD + an async convert job mirroring ai_chat's pattern."""
from datetime import datetime

from django.shortcuts import get_object_or_404
from ninja import Router, Schema

from .models import Document
from .tasks import convert_document

router = Router(tags=['documents'])


class DocumentCreateIn(Schema):
    title: str
    source_path: str


class DocumentListOut(Schema):
    id: int
    title: str
    status: str
    created_at: datetime


class DocumentDetailOut(Schema):
    id: int
    title: str
    source_path: str
    status: str
    markdown: str
    error: str
    created_at: datetime
    updated_at: datetime


class DocumentCreatedOut(Schema):
    id: int
    title: str
    status: str
    job_id: str


@router.get('/', response=list[DocumentListOut], auth=None)
def list_documents(request):
    return list(Document.objects.all())


@router.get('/{document_id}/', response=DocumentDetailOut, auth=None)
def get_document(request, document_id: int):
    return get_object_or_404(Document, pk=document_id)


@router.post('/', response=DocumentCreatedOut, auth=None)
def create_document(request, payload: DocumentCreateIn):
    doc = Document.objects.create(
        title=payload.title, source_path=payload.source_path, status='pending'
    )
    result = convert_document.delay(doc.id)
    return DocumentCreatedOut(id=doc.id, title=doc.title, status=doc.status, job_id=result.id)


@router.delete('/{document_id}/', auth=None)
def delete_document(request, document_id: int):
    doc = get_object_or_404(Document, pk=document_id)
    doc.delete()
    return {'deleted': document_id}
