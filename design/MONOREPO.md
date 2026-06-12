# Phoenix Monorepo Layout

Phoenix now follows the house full-stack layout (same as `health`).

```
phoenix/
├── mobile/        Flutter app (desktop-first)  ── the primary surface
│   └── lib/
│       ├── app/         bootstrap, router (go_router), DI
│       ├── core/        cross-cutting
│       │   └── ai/      InferencePort + SubprocessEngine (llama.cpp)  ★
│       └── features/    chat · models · settings · …
├── backend/       Django + django-ninja + Celery  (cloud/async jobs)
│   ├── config/    settings · api.py · celery.py
│   └── apps/      core · ai_chat
├── frontend/      Next.js 15 (web surface, optional)
├── design/        plans, scenarios, integration, tracker
├── docker/        compose + Dockerfile (pinned via root Makefile)
├── docs/          adr, runbooks
├── scripts/
├── resources/providers/local_provider/   ★ KEEP — llama.cpp engine
└── (view/ + core/ C++ Qt — deleted in P10; preserved on a separate branch)
```

## Stack (matches health)
- **Mobile:** Flutter · Riverpod · go_router · Dio
- **Backend:** Python · Django + django-ninja · Postgres · Redis · Celery
- **Web:** Next.js 15 · TypeScript · TanStack Query

## Boundaries
- **Inference is on-device** (llama.cpp in `mobile/lib/core/ai`). The backend
  never runs an LLM — it handles auth, sync, and Celery jobs.
- One `.env` at repo root (backend + frontend). Compose via `make`, never bare
  `docker compose`.

## Conventions
- Flutter: feature-first (`features/<x>/{data,domain,presentation}`).
- Backend: app routers mounted alphabetically in `config/api.py`; trailing slash
  on every route; migration in the same change as a model edit.
- Files ≤ 200 lines, functions ≤ 50 lines (house rule).
