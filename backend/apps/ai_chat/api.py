"""AI-chat router. Fires async jobs and exposes the /jobs/<id> polling contract."""
from ninja import Router, Schema

from .tasks import deep_search

router = Router(tags=['ai_chat'])


class DeepSearchIn(Schema):
    query: str


class JobOut(Schema):
    job_id: str
    status: str


@router.post('/deep-search/', response=JobOut, auth=None)
def start_deep_search(request, payload: DeepSearchIn):
    """Kick off a deep-search Celery job; returns a job id to poll."""
    result = deep_search.delay(payload.query)
    return JobOut(job_id=result.id, status='queued')


@router.get('/jobs/{job_id}/', response=JobOut, auth=None)
def job_status(request, job_id: str):
    """Poll a job's status (the async-job contract from the design docs)."""
    from celery.result import AsyncResult

    res = AsyncResult(job_id)
    return JobOut(job_id=job_id, status=res.status.lower())
