"""Async document conversion. Lightweight reader now; real Docling drops in later.

Docling (PDF/office -> markdown) will replace the placeholder branch below as a
Celery backend job — see design/scenario/04-cli-and-gguf-tooling.md.
"""
from pathlib import Path

from celery import shared_task
from django.conf import settings

TEXT_SUFFIXES = {'.md', '.txt', '.markdown'}


@shared_task
def convert_document(document_id: int) -> dict:
    from .models import Document

    doc = Document.objects.get(pk=document_id)
    doc.status = 'converting'
    doc.save(update_fields=['status', 'updated_at'])

    try:
        markdown = _convert(doc.source_path)
    except Exception as exc:  # noqa: BLE001 - surface any read/convert failure to the user
        doc.status = 'failed'
        doc.error = str(exc)
        doc.save(update_fields=['status', 'error', 'updated_at'])
        return {'document_id': document_id, 'status': 'failed'}

    doc.markdown = markdown
    doc.status = 'ready'
    doc.error = ''
    doc.save(update_fields=['markdown', 'status', 'error', 'updated_at'])
    return {'document_id': document_id, 'status': 'ready'}


def _resolve(source_path: str) -> Path:
    root = Path(settings.DOCUMENTS_ROOT)
    path = (root / source_path).resolve()
    if not path.is_relative_to(root):
        raise ValueError(f'source outside the documents root: {source_path}')
    return path


def _convert(source_path: str) -> str:
    path = _resolve(source_path)
    if path.suffix.lower() in TEXT_SUFFIXES:
        return path.read_text(encoding='utf-8')
    if not path.exists():
        raise FileNotFoundError(f'source not found: {source_path}')
    return f'> Docling will convert `{path.name}` ({path.suffix or "unknown"}) here.'
