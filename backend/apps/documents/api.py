"""Documents router. CRUD + an async convert job mirroring ai_chat's pattern."""
from datetime import datetime

from django.shortcuts import get_object_or_404
from ninja import Router, Schema
from pydantic import Field

from apps.accounts.auth import session_token_auth

from .models import Document
from .tasks import convert_document

router = Router(tags=['documents'], auth=session_token_auth)


class DocumentCreateIn(Schema):
    title: str = Field(max_length=255)
    source_path: str = Field(max_length=1024)


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


@router.get('/', response=list[DocumentListOut])
def list_documents(request):
    return list(Document.objects.filter(owner=request.auth))


@router.get('/{document_id}/', response=DocumentDetailOut)
def get_document(request, document_id: int):
    return get_object_or_404(Document, pk=document_id, owner=request.auth)


@router.post('/', response=DocumentCreatedOut)
def create_document(request, payload: DocumentCreateIn):
    doc = Document.objects.create(
        owner=request.auth, title=payload.title, source_path=payload.source_path,
        status='pending',
    )
    result = convert_document.delay(doc.id)
    return DocumentCreatedOut(id=doc.id, title=doc.title, status=doc.status, job_id=result.id)


@router.delete('/{document_id}/')
def delete_document(request, document_id: int):
    doc = get_object_or_404(Document, pk=document_id, owner=request.auth)
    doc.delete()
    return {'deleted': document_id}
