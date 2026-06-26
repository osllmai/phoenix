"""django-ninja schemas for the Fleet API (read + control contracts)."""
from datetime import datetime

from ninja import Schema


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

    @staticmethod
    def resolve_lane_count(obj) -> int:
        return obj.lanes.count()

    @staticmethod
    def resolve_done_count(obj) -> int:
        return obj.lanes.filter(state='done').count()


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
    prompt: str
    agents: list[str]
    base_branch: str = 'app/developer'
    race_mode: bool = True


class MergeIn(Schema):
    lane_id: int
    target_branch: str = 'app/developer'
