<div align="center">

<img src="docs/assets/phoenix-ember.svg" alt="Phoenix" width="120" />

# Phoenix

### Run large language models **100% on your own machine** — private, offline, yours.

A full-stack, open-source workbench for local LLMs. Flutter desktop UI over a
**llama.cpp** engine, a pure-Dart core SDK, and an optional Django/Celery backend —
no cloud, no API keys, no data leaving your device.

[![Stars](https://img.shields.io/github/stars/osllmai/phoenix?style=social)](https://github.com/osllmai/phoenix/stargazers)
[![License: AGPL v3](https://img.shields.io/badge/license-AGPL--3.0-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-desktop-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![llama.cpp](https://img.shields.io/badge/engine-llama.cpp-000000.svg)](https://github.com/ggerganov/llama.cpp)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](#contributing)

**⭐ If Phoenix is useful to you, [star the repo](https://github.com/osllmai/phoenix) — it genuinely helps.**

</div>

---

<div align="center">
<img src="docs/assets/preview-D-chat.png" alt="Phoenix chat — desktop" width="49%" />
<img src="docs/assets/preview-D-models.png" alt="Phoenix local model catalog — desktop" width="49%" />
<br/><sub><i>Desktop UI — design preview (the app is in active development).</i></sub>
</div>

## Why Phoenix?

- 🔒 **Truly private** — inference runs on-device in `phoenix_core` + `engine/`. The backend **never** runs an LLM. Your prompts never leave the machine.
- ⚡ **Local-first, cloud-optional** — works fully offline; an optional gateway speaks OpenAI `/v1/chat/completions` + Anthropic `/v1/messages` so existing tools just point at `localhost`.
- 🧩 **Extensible by design** — features load as self-registering modules (`FeatureModule`); add one file, not a monolithic rewrite.
- 📦 **GGUF model catalog** — import `.gguf` files from disk, load/switch/remove, favorites — all managed on-device.
- 🛠️ **One core, many surfaces** — a single pure-Dart SDK powers the Flutter app, an HTTP gateway, and a CLI.

## Features

| | |
|---|---|
| 💬 **Chat** | Streaming local inference with system prompts + tunable sampling. |
| 🧠 **Local models** | Add / load / switch / remove GGUF models; pick your active model. |
| 📄 **Documents & search** | Doc-convert (Docling) + retrieval for chat-with-your-files *(in progress)*. |
| 🎙️ **Speech** | On-device transcription via whisper.cpp *(planned)*. |
| 🔌 **OpenAI/Anthropic gateway** | Drop-in local endpoint for existing clients *(WIP)*. |
| 🧱 **Extensions** | Install capabilities on demand — keep the core lightweight. |

## Quick start

```bash
# Desktop app (Flutter)
cd mobile && flutter pub get && flutter run -d linux   # or -d macos / -d windows

# Core + app tests (pure Dart)
bash mobile/tool/run_tests.sh

# Optional backend + web (Docker)
cp .env.example .env && make up                        # api :16000 · web :3000
```

> **Inference is on-device.** Point Phoenix at a `.gguf` you already have, or grab one
> from Hugging Face, and start chatting — no account, no network required.

## Architecture

| Path | What |
|------|------|
| `mobile/` | Flutter app (desktop-first). UI only — no business logic. |
| `packages/phoenix_core/` | Pure-Dart SDK: engine + chat/model services + SQLite + `PhoenixCore` facade. |
| `packages/phoenix_server/` | OpenAI/Anthropic-compatible HTTP gateway over the core *(WIP)*. |
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
[Docling](https://github.com/docling-project/docling) ·
[whisper.cpp](https://github.com/ggerganov/whisper.cpp)

<div align="center"><sub>Built with 🔥 by the osllmai community — <a href="https://github.com/osllmai/phoenix">star us on GitHub</a>.</sub></div>
