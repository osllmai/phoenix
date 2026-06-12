"""Async jobs for the AI chat surface.

These offload long-running / networked work from the device (deep-search,
document conversion, embeddings) — see design/scenario/03-django-celery-hybrid.md.
Inference itself stays on-device (llama.cpp); it never runs here.
"""
from celery import shared_task


@shared_task
def deep_search(query: str) -> dict:
    """Placeholder: crawl + rank sources for a query (arXiv etc.). P8.3."""
    return {'query': query, 'results': [], 'status': 'not_implemented'}


@shared_task
def build_embeddings(document_id: str) -> dict:
    """Placeholder: build a RAG index for an uploaded document. P8.4."""
    return {'document_id': document_id, 'vectors': 0, 'status': 'not_implemented'}
