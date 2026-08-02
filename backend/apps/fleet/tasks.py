"""Async jobs for the Fleet surface.

Persistence + orchestration state live here; the actual sandboxed worktree/PTY
executor (one egress-locked container per agent, OSC-title status, git merge) is
a separate desktop runtime — NOT the Django backend, which never runs an LLM.
See design/future/orca-ade-research.md for that subsystem's plan.
"""
from celery import shared_task


@shared_task
def fan_out_run(run_id: int) -> dict:
    """Placeholder: hand the run to the desktop runtime, which spawns one
    egress-locked worktree per lane and streams status back. Not implemented."""
    return {'run_id': run_id, 'status': 'not_implemented'}
