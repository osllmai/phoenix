from __future__ import annotations

from ninja import Schema


class UserMeRead(Schema):
    id: str
    email: str
    full_name: str
    locale: str

    @staticmethod
    def resolve_id(obj) -> str:
        return str(obj.id)


class UserMeWrite(Schema):
    full_name: str | None = None
    locale: str | None = None
