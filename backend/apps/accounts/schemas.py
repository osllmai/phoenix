from __future__ import annotations

from ninja import Schema
from pydantic import Field


class UserMeRead(Schema):
    id: str
    email: str
    full_name: str
    locale: str

    @staticmethod
    def resolve_id(obj) -> str:
        return str(obj.id)


class UserMeWrite(Schema):
    full_name: str | None = Field(None, max_length=120)
    locale: str | None = Field(None, max_length=8)
