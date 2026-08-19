"""Fleet router. Fan one prompt across agents (each an isolated worktree),
read run/lane/event state, and merge the winning lane.

The execution runtime is out of scope here (see tasks.py); these endpoints are
the persistence + control contract the web and Flutter Fleet screens consume.
"""
from django.db import transaction
from django.db.models import Count, Prefetch, Q
from django.shortcuts import get_object_or_404
from ninja import Router

from .models import FleetEvent, FleetLane, FleetRun
from .schemas import FanOutIn, MergeIn, RunDetailOut, RunListOut
from .tasks import fan_out_run

router = Router(tags=['fleet'])


def _detail_qs():
    return FleetRun.objects.prefetch_related(
        Prefetch('lanes', queryset=FleetLane.objects.all()),
        Prefetch('events', queryset=FleetEvent.objects.all()),
    )


@router.get('/runs/', response=list[RunListOut], auth=None)
def list_runs(request, status: str | None = None):
    qs = FleetRun.objects.annotate(
        lane_count=Count('lanes'),
        done_count=Count('lanes', filter=Q(lanes__state='done')),
    ).order_by('-created_at')
    if status:
        qs = qs.filter(status=status)
    return list(qs)


@router.post('/runs/', response=RunDetailOut, auth=None)
def fan_out(request, payload: FanOutIn):
    """Create a run + one queued lane per agent, then hand off to the runtime."""
    run = FleetRun.objects.create(
        prompt=payload.prompt,
        base_branch=payload.base_branch,
        race_mode=payload.race_mode,
    )
    for i, agent in enumerate(payload.agents, start=1):
        FleetLane.objects.create(
            run=run,
            agent=agent,
            worktree_path=f'phoenix-{agent[:2]}-{i}',
        )
    fan_out_run.delay(run.id)
    return get_object_or_404(_detail_qs(), pk=run.pk)


@router.get('/runs/{run_id}/', response=RunDetailOut, auth=None)
def get_run(request, run_id: int):
    return get_object_or_404(_detail_qs(), pk=run_id)


@router.post('/runs/{run_id}/merge/', response=RunDetailOut, auth=None)
def merge_winner(request, run_id: int, payload: MergeIn):
    """Mark the chosen lane the winner and the run merged onto the target branch."""
    with transaction.atomic():
        run = get_object_or_404(FleetRun.objects.select_for_update(), pk=run_id)
        lane = get_object_or_404(FleetLane, pk=payload.lane_id, run=run)
        run.lanes.update(is_winner=False)
        FleetLane.objects.filter(pk=lane.pk).update(is_winner=True)
        run.status = 'merged'
        run.base_branch = payload.target_branch
        run.save(update_fields=['status', 'base_branch'])
    return get_object_or_404(_detail_qs(), pk=run.pk)
