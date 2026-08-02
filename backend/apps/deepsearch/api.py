"""DeepSearch router. Fires a local-retrieval Celery job; poll for status."""
from datetime import datetime

from django.shortcuts import get_object_or_404
from ninja import Router, Schema

from .models import SearchRun
from .tasks import run_search

router = Router(tags=['deepsearch'])


class SearchStartIn(Schema):
    query: str
    scope: str = 'local'
    depth: str = 'standard'


class SearchStartedOut(Schema):
    id: int
    status: str
    job_id: str


class SearchListOut(Schema):
    id: int
    query: str
    status: str
    created_at: datetime


class SearchDetailOut(Schema):
    id: int
    query: str
    scope: str
    depth: str
    status: str
    answer: str
    sources: list
    error: str
    created_at: datetime


@router.post('/', response=SearchStartedOut, auth=None)
def start_search(request, payload: SearchStartIn):
    run = SearchRun.objects.create(
        query=payload.query, scope=payload.scope, depth=payload.depth, status='pending'
    )
    result = run_search.delay(run.id)
    return SearchStartedOut(id=run.id, status=run.status, job_id=result.id)


@router.get('/', response=list[SearchListOut], auth=None)
def list_searches(request):
    return list(SearchRun.objects.all())


@router.get('/{run_id}/', response=SearchDetailOut, auth=None)
def get_search(request, run_id: int):
    return get_object_or_404(SearchRun, pk=run_id)
