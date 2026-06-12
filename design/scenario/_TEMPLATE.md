# <scenario name> — `METHOD /api/v1/<app>/<path>`

The contract every surface (backend, web, flutter, extension) builds against. One contract, no per-surface re-spec.

## Auth & scoping
`auth=JWTBearer()` (or note anon + per-IP throttle). Data scoped by `user`/`tenant`.

## Request
```json
{ "field": "type — required|optional, constraints" }
```

## Success — `200` (or `201`)
```json
{ "field": "value" }
```

## Errors
| Status | When | Body |
|--------|------|------|
| `401` | unauthenticated | `{ "detail": "…" }` |
| `403` | not owner / denied | `{ "detail": "…" }` |
| `422` | validation | `{ "detail": [{ "loc": …, "msg": … }] }` |

## Notes
Pagination, idempotency, rate limit, side effects (Celery tasks, registry hooks).
