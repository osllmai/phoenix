# Phase NN — <phase name>

## Goal
One paragraph: the intended outcome of this phase.

## Scope
What is created / registered / configured (apps, models, endpoints, files).

## Models / Endpoints
- Models: `Model(field, …)` with indexes + constraints.
- Endpoints: `METHOD /api/v1/<app>/…` — `auth=JWTBearer()`, scoped by `user`/`tenant`.
- Contract: `design/scenario/apps/<app>/<scenario>.md` · types: `design/contract/` (generated).

## Tasks
- [ ] …
- [ ] makemigrations + migrate (DB change ships its migration in the same change)
- [ ] `assertNumQueries` N+1 budget test

## Tests
What's covered (happy path + each state + edge cases from `design/synthetic_data/<app>/`).

## Done when
- Migrations apply clean · tests green · `ruff` clean · file sizes ≤200 lines.
- All applicable states render (empty/loading/first-run/success/error/denied).
- Board updated in `<app>/README.md` + `PROGRESS.md` + `INDEX.md`.

## Dependencies
Blocked by: … · Blocks: …
