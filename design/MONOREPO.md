# Phoenix Monorepo Layout

Phoenix now follows the house full-stack layout (same as `health`).

```
phoenix/
├── mobile/        Flutter app (desktop-first) — the UI surface
│   ├── lib/
│   │   ├── app/        bootstrap · router · shell · feature composition root
│   │   ├── core/       Flutter glue: ai/ (Riverpod engine provider) · feature/ (registry)
│   │   └── features/   chat · models · …  (presentation + module, NO business logic)
│   └── assets/     phoenix.svg · logos/ · fonts/ · catalog/ (model registry seed)
├── packages/      shared pure-Dart (importable by UI, server, CLI)
│   ├── phoenix_core/    SDK: engine · chat · models · storage · PhoenixCore facade
│   └── phoenix_server/  HTTP gateway: OpenAI/Anthropic over phoenix_core (WIP)
├── backend/       Django + django-ninja + Celery  (cloud/async jobs)
│   ├── config/    settings · api.py · celery.py
│   └── apps/      core · ai_chat
├── frontend/      Next.js 15 (web surface, optional)
├── engine/        vendored native runtime
│   └── local_provider/   ★ llama.cpp / gpt4all engine (applocal_provider + libs)
├── design/        scenarios · integration · MONOREPO.md · TRACKER.md
├── docker/        compose + Dockerfile (pinned via root Makefile)
├── docs/adr/      architecture decision records
└── scripts/
```

## Why `packages/` (differs from health)
health's backend is Python, so there is no shared Dart code. Phoenix's core IS
Dart and is shared by three consumers — the Flutter UI, the HTTP gateway, and a
CLI — so it lives in a **pure-Dart package** (`phoenix_core`). A core embedded in
`mobile/lib/` would be a Flutter package and could not be imported by a headless
server/CLI. This is the "both API + SDK" decision made concrete.

## Stack (matches health)
- **Mobile:** Flutter · Riverpod · go_router · Dio
- **Core/Server:** pure Dart · sqflite · shelf (gateway)
- **Backend:** Python · Django + django-ninja · Postgres · Redis · Celery
- **Web:** Next.js 15 · TypeScript · TanStack Query

## Boundaries
- **Inference is on-device** (`packages/phoenix_core`, engine binary in `engine/`).
  The Flutter app owns no business logic — it consumes `phoenix_core`. The Django
  backend never runs an LLM — it handles auth, sync, and Celery jobs.
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
