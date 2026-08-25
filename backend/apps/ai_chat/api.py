"""AI-chat router. Fires the shared DeepSearch job and exposes the /jobs/<id>
polling contract.

Retrieval itself lives in `apps.deepsearch` — this surface delegates rather than
carrying a second implementation. Inference stays on-device (llama.cpp); the
backend never runs an LLM.
"""
from ninja import Router, Schema
from pydantic import Field

from apps.accounts.auth import session_token_auth
from apps.deepsearch.models import SearchRun
from apps.deepsearch.tasks import run_search

router = Router(tags=['ai_chat'], auth=session_token_auth)


class DeepSearchIn(Schema):
    query: str = Field(max_length=1024)


class DeepSearchStartedOut(Schema):
    job_id: str
    status: str
    run_id: int


class JobOut(Schema):
    job_id: str
    status: str


@router.post('/deep-search/', response=DeepSearchStartedOut)
def start_deep_search(request, payload: DeepSearchIn):
    """Kick off the shared DeepSearch job; poll /jobs/<job_id>/ or read the run."""
    run = SearchRun.objects.create(owner=request.auth, query=payload.query, status='pending')
    result = run_search.delay(run.id)
    return DeepSearchStartedOut(job_id=result.id, status='queued', run_id=run.id)


@router.get('/jobs/{job_id}/', response=JobOut)
def job_status(request, job_id: str):
    """Poll a job's status (the async-job contract from the design docs)."""
    from celery.result import AsyncResult

    try:
        status = AsyncResult(job_id).status.lower()
    except Exception:  # noqa: BLE001 - an unreachable result backend is not a client error
        status = 'unknown'
    return JobOut(job_id=job_id, status=status)
