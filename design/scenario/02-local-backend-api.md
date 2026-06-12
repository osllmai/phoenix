# 02 — Expose the backend as a local API

Make the engine a **local server** and let the Flutter UI be just *one client* of
it. Other apps, scripts, and CLIs become clients of the same door.

## Architecture with exposed backend

```
        ┌──────────────┐   ┌──────────────┐   ┌──────────────────────┐
        │ Flutter UI   │   │ User's apps  │   │ curl / Python / Node │
        │ (your app)   │   │ scripts, CLI │   │ LangChain, OpenAI SDK│
        └──────┬───────┘   └──────┬───────┘   └──────────┬───────────┘
               │                  │                      │
               │  HTTP / WebSocket (localhost:port)      │
               │  ── OpenAI-compatible REST + SSE ──     │
               └──────────────────┼──────────────────────┘
                                  ▼
   ╔══════════════════════════════════════════════════════════════════╗
   ║                NAI BACKEND  (one process, Dart)                    ║
   ║  ┌──────────────────────────────────────────────────────────┐    ║
   ║  │  API SERVER  (shelf)                                     │    ║
   ║  │  POST /v1/chat/completions   GET /v1/models             │    ║
   ║  │  WS  /v1/stream              POST /v1/embeddings        │    ║
   ║  │  ── auth (API key/token) · rate-limit · CORS ──         │    ║
   ║  └───────────────────────────┬──────────────────────────────┘    ║
   ║  ┌───────────────────────────▼──────────────────────────────┐    ║
   ║  │  SERVICE LAYER  (Chat · Models · DeepSearch · Embeddings) │    ║
   ║  └──────┬────────────────────────────────────┬──────────────┘    ║
   ║  ┌──────▼──────┐                     ┌────────▼────────┐          ║
   ║  │ sqflite/drift│                     │  InferencePort  │          ║
   ║  └─────────────┘                     └────────┬────────┘          ║
   ╚═══════════════════════════════════════════════┼═══════════════════╝
                                  ┌────────────────▼─────────────────┐
                                  │ applocal_provider (UNCHANGED)    │
                                  │ gpt4all-backend → llama.cpp/GGUF │
                                  └──────────────────────────────────┘
```

## The shift

```
   BEFORE:  UI ──► Service ──► InferencePort ──► llama.cpp
   NOW:     UI ──► HTTP ──► [ Server ──► Service ──► InferencePort ] ──► llama.cpp
                            ▲
           external apps ───┘   (same door, same contract)
```

The Flutter UI eats its own dogfood — it calls the same endpoints external users
get. Phoenix already does this in C++ (`core/developer/server/`:
`chatserver`, `crudapi`, `chatapi`, `modelapi`); this ports the concept.

## Best-practice rules

| Concern | Recommendation |
|---|---|
| **Wire format** | Be **OpenAI-API-compatible** (`/v1/chat/completions`) → works with existing SDKs/LangChain/Ollama tooling, zero docs |
| **Bind address** | Default `127.0.0.1` only; explicit `--host 0.0.0.0` opt-in before LAN exposure |
| **Auth** | API key/token even on localhost — any browser page can hit `localhost` |
| **Streaming** | SSE for REST (`text/event-stream`), WebSocket for bidirectional; map `__DONE_PROMPTPROCESS__` → stream-end |
| **Concurrency** | One subprocess = one stream. Add request queue + per-model worker pool |
| **Lifecycle** | Server owns the subprocess pool: load-on-demand, idle-evict, health-check/restart |

## Concurrency: one engine, many callers

```
  Option 1: Queue          Option 2: Worker pool
  ┌─────────────┐          ┌──────────────────────────┐
  │ req → req → │          │ modelA → provider proc #1 │
  │ serialized  │          │ modelB → provider proc #2 │
  └──────┬──────┘          │ modelA → (reuse #1, queue)│
         │ 1 process       └──────────────────────────┘
   simplest, slow           more RAM, true concurrency
```

Start with **Queue**; move to **Worker pool** when load justifies the RAM.
