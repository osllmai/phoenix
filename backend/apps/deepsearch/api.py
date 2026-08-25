"""DeepSearch router. Fires a local-retrieval Celery job; poll for status."""
from datetime import datetime
from typing import Literal

from django.shortcuts import get_object_or_404
from ninja import Router, Schema
from pydantic import Field

from apps.accounts.auth import session_token_auth

from .models import SearchRun
from .tasks import run_search

router = Router(tags=['deepsearch'], auth=session_token_auth)


class SearchStartIn(Schema):
    query: str = Field(max_length=1024)
    scope: Literal['local', 'web'] = 'local'
    depth: Literal['quick', 'standard', 'deep'] = 'standard'


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


@router.post('/', response=SearchStartedOut)
def start_search(request, payload: SearchStartIn):
    run = SearchRun.objects.create(
        owner=request.auth, query=payload.query, scope=payload.scope,
        depth=payload.depth, status='pending',
    )
    result = run_search.delay(run.id)
    return SearchStartedOut(id=run.id, status=run.status, job_id=result.id)


@router.get('/', response=list[SearchListOut])
def list_searches(request):
    return list(SearchRun.objects.filter(owner=request.auth))


@router.get('/{run_id}/', response=SearchDetailOut)
def get_search(request, run_id: int):
    return get_object_or_404(SearchRun, pk=run_id, owner=request.auth)
