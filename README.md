<h1 align="center">🔥 Phoenix</h1>

<p align="center"><b>Local LLM app — Flutter UI over llama.cpp, no internet required.</b></p>

Phoenix is a full-stack monorepo for running large language models **on-device**.
The Flutter app talks to a local **llama.cpp** engine; a Django + Celery backend
handles cloud/async work; a pure-Dart core is shared across the UI, an HTTP
gateway, and a CLI.

> Re-platformed from the original Qt/QML app. The legacy Qt source lives on a
> separate branch; this tree is Flutter-only.

## Layout

| Path | What |
|------|------|
| `mobile/` | Flutter app (desktop-first). UI only — no business logic. |
| `packages/phoenix_core/` | Pure-Dart SDK: engine + chat/model services + SQLite + `PhoenixCore` facade. |
| `packages/phoenix_server/` | OpenAI/Anthropic-compatible HTTP gateway over the core (WIP). |
| `backend/` | Django + django-ninja + Celery — auth, sync, async jobs (deep-search, Docling, embeddings). |
| `frontend/` | Next.js 15 web surface (optional). |
| `engine/local_provider/` | Vendored llama.cpp / gpt4all engine binary. |
| `design/` | Scenarios, integration plans, `MONOREPO.md`, `TRACKER.md`. |
| `docker/` · `docs/adr/` · `scripts/` | Infra, decisions, tooling. |

See [`design/MONOREPO.md`](design/MONOREPO.md) for the full architecture and
[`design/TRACKER.md`](design/TRACKER.md) for build status.

## Quick start

```bash
# Mobile (Flutter)
cd mobile && flutter pub get && flutter run -d linux

# Core tests (pure Dart) + app tests
bash mobile/tool/run_tests.sh

# Backend + web + infra (docker)
cp .env.example .env && make up      # api :16000 · web :3000
```

## Principle

**Inference is on-device** (`phoenix_core` + `engine/`). The backend never runs an
LLM. Features load as self-registering modules (`FeatureModule`) so the app scales
without a monolithic shell.

## Acknowledgements

[llama.cpp](https://github.com/ggerganov/llama.cpp) ·
[gpt4all](https://github.com/nomic-ai/gpt4all) ·
[Docling](https://github.com/docling-project/docling) · whisper.cpp
