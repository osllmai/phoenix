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

## Feature extensions (the app will be large)

Features load as **self-registering modules**, never hard-wired into the shell:

```
core/feature/feature_module.dart   FeatureModule contract (routes + navItems)
core/feature/feature_registry.dart FeatureRegistry — aggregates enabled modules
features/<x>/<x>_module.dart        each feature's module (Chat, Models, …)
app/features.dart                   composition root: the enabled list  ← edit here
app/router.dart                     router derived from the registry
app/app_shell.dart                  NavigationRail built from registry navItems
```

Adding a feature = create its `FeatureModule` + add one line to `app/features.dart`.
The router and nav update automatically; no central screen imports. As the app
grows, gate features behind flags in `features.dart`. Next features to register:
documents (Docling), deepsearch, developer, speech, settings.

## Conventions
- Flutter: feature-first (`features/<x>/{data,domain,presentation}`) + a
  `<x>_module.dart` that registers the feature.
- Backend: app routers mounted alphabetically in `config/api.py`; trailing slash
  on every route; migration in the same change as a model edit.
- Files ≤ 200 lines, functions ≤ 50 lines (house rule).
