"""Local retrieval for a SearchRun. Keyword/icontains over the Documents corpus.

Real vector RAG (pgvector + embeddings) and on-device answer synthesis drop in
here later; this builds extractive sources only and never runs an LLM.
"""
import re

from celery import shared_task
from django.apps import apps

TOP_N_BY_DEPTH = {'quick': 3, 'standard': 5, 'deep': 8}
SNIPPET_RADIUS = 120


@shared_task
def run_search(run_id: int) -> dict:
    from .models import SearchRun

    run = SearchRun.objects.get(pk=run_id)
    run.status = 'running'
    run.save(update_fields=['status'])

    try:
        sources = _retrieve(run.query, run.depth, run.owner_id)
    except Exception as exc:  # noqa: BLE001 - surface any retrieval failure to the user
        run.status = 'failed'
        run.error = str(exc)
        run.save(update_fields=['status', 'error'])
        return {'run_id': run_id, 'status': 'failed'}

    run.sources = sources
    run.answer = _extractive_answer(sources)
    run.status = 'ready'
    run.error = ''
    run.save(update_fields=['sources', 'answer', 'status', 'error'])
    return {'run_id': run_id, 'status': 'ready', 'sources': len(sources)}


def _terms(query: str) -> list[str]:
    return [t for t in re.findall(r'\w+', query.lower()) if t]


def _retrieve(query: str, depth: str, owner_id) -> list[dict]:
    Document = apps.get_model('documents', 'Document')
    terms = _terms(query)
    if not terms:
        return []

    top_n = TOP_N_BY_DEPTH.get(depth, TOP_N_BY_DEPTH['standard'])
    scored = []
    for doc in Document.objects.filter(owner_id=owner_id):
        haystack = f'{doc.title}\n{doc.markdown}'.lower()
        freq = sum(haystack.count(term) for term in terms)
        if freq == 0:
            continue
        scored.append((freq, doc))

    if not scored:
        return []

    scored.sort(key=lambda pair: pair[0], reverse=True)
    top = scored[: top_n]
    max_freq = top[0][0]
    return [
        {
            'document_id': doc.id,
            'title': doc.title,
            'snippet': _snippet(doc, terms),
            'relevance': round(freq / max_freq, 4),
        }
        for freq, doc in top
    ]


def _snippet(doc, terms: list[str]) -> str:
    text = doc.markdown or doc.title
    low = text.lower()
    pos = min((low.find(t) for t in terms if low.find(t) != -1), default=-1)
    if pos == -1:
        return text[: SNIPPET_RADIUS * 2].strip()
    start = max(0, pos - SNIPPET_RADIUS)
    end = pos + SNIPPET_RADIUS
    return text[start:end].strip()


def _extractive_answer(sources: list[dict]) -> str:
    if not sources:
        return 'No local sources matched. On-device synthesis produces the final answer.'
    body = '\n\n'.join(f"[{s['title']}] {s['snippet']}" for s in sources)
    return f'{body}\n\n(Extractive sources only — on-device synthesis produces the final answer.)'
