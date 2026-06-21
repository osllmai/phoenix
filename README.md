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
cp .env.example .env && make up      # web → localhost:37001 · api → localhost:37000
```

## Using Phoenix

Everything runs **on your machine** — pick a surface, load a model, and go.

**1. Launch**
- **Desktop app (Flutter)** — the functional on-device app:
  `cd mobile && flutter run -d linux` (or `-d macos` / `-d windows`).
- **Web** — `cp .env.example .env && make up`, then open **http://localhost:37001**.
  The browser talks to the on-device gateway (`phoenix_server`) at
  `NEXT_PUBLIC_API_BASE_URL` (default `http://localhost:24678`).

**2. Add a model** (under **Models** — first launch walks you through it)
- **Local** — point Phoenix at a `.gguf` you already have (*Models → Add*), or
- **Browse** — download one from the catalog, or
- **Online / Providers** — connect a hosted provider with your own key (BYOK).

Local models run via llama.cpp — nothing leaves your device.

**3. Work**
- **Chat** — talk to the loaded model (markdown, code, streaming).
- **Documents** — add a PDF/office file; Phoenix converts + indexes it (Docling).
- **DeepSearch** — ask questions grounded in your documents (RAG).
- **Speech** — transcribe audio on-device (whisper.cpp).
- **Forecasting** — time-series forecasts (TimesFM). · **Extensions** — add features on demand.

**4. Use the local API** (developers) — *Developer → Server* exposes an
OpenAI/Anthropic-compatible endpoint; point any client at your local gateway:

```bash
curl http://localhost:24678/v1/chat/completions \
  -H 'content-type: application/json' \
  -d '{"model":"local","messages":[{"role":"user","content":"Hello"}]}'
```

> The Flutter desktop app is the fully wired surface today; the web app ships the
> full UI with live models, and its remaining data flows wire to the backend as it lands.

## Principle

**Inference is on-device** (`phoenix_core` + `engine/`). The backend never runs an
LLM. Features load as self-registering modules (`FeatureModule`) so the app scales
without a monolithic shell.

## Acknowledgements

[llama.cpp](https://github.com/ggerganov/llama.cpp) ·
[gpt4all](https://github.com/nomic-ai/gpt4all) ·
[Docling](https://github.com/docling-project/docling) · whisper.cpp
