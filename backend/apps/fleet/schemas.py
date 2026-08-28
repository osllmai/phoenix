"""django-ninja schemas for the Fleet API (read + control contracts)."""
from datetime import datetime
from typing import Annotated

from ninja import Schema
from pydantic import Field


class LaneOut(Schema):
    id: int
    agent: str
    role: str
    worktree_path: str
    state: str
    status_label: str
    summary: str
    additions: int
    deletions: int
    files_changed: int
    elapsed: str
    route: str
    cost: str
    is_winner: bool


class EventOut(Schema):
    at: str
    actor: str
    text: str
    outcome: str


class RunListOut(Schema):
    id: int
    prompt: str
    base_branch: str
    race_mode: bool
    status: str
    created_at: datetime
    lane_count: int
    done_count: int


class RunDetailOut(Schema):
    id: int
    prompt: str
    base_branch: str
    race_mode: bool
    status: str
    created_at: datetime
    lanes: list[LaneOut]
    events: list[EventOut]

    @staticmethod
    def resolve_lanes(obj) -> list:
        return list(obj.lanes.all())

    @staticmethod
    def resolve_events(obj) -> list:
        return list(obj.events.all())


class FanOutIn(Schema):
    prompt: str = Field(max_length=500)
    agents: list[Annotated[str, Field(max_length=64)]] = Field(max_length=32)
    base_branch: str = Field('app/developer', max_length=200)
    race_mode: bool = True


class MergeIn(Schema):
    lane_id: int
    target_branch: str = Field('app/developer', max_length=200)
