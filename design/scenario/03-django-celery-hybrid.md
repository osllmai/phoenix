# 03 — Django + Celery backend (hybrid)

Match the house standard (Django + DRF + Celery + Redis, as in `health`,
`keytype`, `vesper`, `nai-integrations`, `stock`) **without** breaking Phoenix's
offline-first identity.

## Core tension

Phoenix's selling point is **on-device, offline, llama.cpp**. Django + Celery is a
**server-side** stack. You cannot run llama.cpp inference inside a Celery worker
and still claim "works with no internet."

→ Answer is a **hybrid**: the engine stays local; Django + Celery handle what
genuinely benefits from a server.

## Architecture

```
┌──────────────────────────────────────────────────────────────────────┐
│                        FLUTTER APP  (client)                          │
│   chat · models · deepsearch · settings · developer                   │
└──────┬──────────────────────────────────────────┬─────────────────────┘
       │ LOCAL (offline-capable)                   │ CLOUD (needs internet)
       │ dart:io / localhost                       │ HTTPS REST + WS
       ▼                                           ▼
┌──────────────────────┐          ╔═══════════════════════════════════════╗
│ InferencePort        │          ║      DJANGO BACKEND  (DRF)            ║
│  → applocal_provider │          ║  /api/auth  /api/models  /api/sync    ║
│  → llama.cpp / GGUF  │          ║  /api/deepsearch  /api/jobs/<id>      ║
│  ✓ runs with NO net  │          ║  ── token auth · throttle · CORS ──   ║
└──────────────────────┘          ╚════════════════┬══════════════════════╝
   stays on the device                             │ .delay() / apply_async
                                                    ▼
                                   ┌────────────────────────────────┐
                                   │  BROKER   (Redis / RabbitMQ)   │
                                   └────────────────┬───────────────┘
                                                    ▼
                          ╔═════════════════════════════════════════════╗
                          ║         CELERY WORKERS (async jobs)         ║
                          ║  • arXiv / deep-search crawl + rank         ║
                          ║  • document convert (MarkItDown/Docling)    ║
                          ║  • embeddings / RAG index build             ║
                          ║  • HuggingFace catalog sync & mirroring     ║
                          ║  • clinical NLP server backend (OpenMed)    ║
                          ║  • usage rollups / notifications            ║
                          ╚═══════════════┬═════════════════════════════╝
                                          ▼
                          ┌───────────────────────────────────────┐
                          │ Postgres · object storage · pgvector  │
                          │ Celery Beat (scheduled) · Flower (mon) │
                          └───────────────────────────────────────┘
```

## Decision rule — what runs where

| Workload | Local (device) | Django + Celery |
|---|---|---|
| **LLM token generation** | ✅ llama.cpp — **never** moves | ❌ (defeats offline) |
| Conversation/message store | ✅ sqflite | 🔁 optional cloud **sync** |
| Model catalog / HF browse | cache | ✅ source of truth, mirrored |
| Deep-search / arXiv crawl | — | ✅ **Celery task** |
| Document → markdown convert | small files | ✅ **Celery task** (Python-heavy) |
| Embeddings / RAG indexing | small | ✅ **Celery task** + pgvector |
| Clinical NLP (verified de-id) | best-effort only | ✅ server backend (`health`) |
| Auth / accounts / billing | — | ✅ Django |

**Rule of thumb:** inference is local; long-running/networked/Python-heavy jobs
are Celery tasks; Django is the API gateway + system of record.

## Async-job contract

Client fires request → gets `job_id` → polls `/api/jobs/<id>` (or WS push) while a
Celery worker runs. This maps directly onto the existing C++ worker threads
(`arxivsearchworker`, `convertworker`, `tokenizerworker`) — moving worker logic to
a place built for it.

## Why hybrid beats "all in Django"

- **Offline still works** — pull the network cable, chat still runs.
- **Heavy work stops blocking the UI** — deep-search / doc-convert become tasks.
- **Reuses your stack** — shared auth, deploy, monitoring with other NAI backends.

## Open decision

- **New `phoenix/backend/` Django service** (clean separation), **or**
- **Fold endpoints into an existing project** (`nai-integrations` / `health`).

This choice drives the API layout. A sample DRF app + one Celery task
(deep-search) + the `/api/jobs/<id>` polling contract is the recommended first
slice.
