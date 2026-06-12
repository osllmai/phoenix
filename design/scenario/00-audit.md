# 00 — Feasibility Audit: Phoenix → Flutter (keep llama.cpp)

## Verdict

**Feasible.** The architecture is unusually favorable because llama.cpp is
already fully decoupled from Qt. The catch: "go Flutter" and "keep llama.cpp"
are two *different* decisions — the existing in-house Flutter package
(`nai_edge_ai`) does **not** use llama.cpp.

## What Phoenix is today

| Layer | Tech | Size |
|---|---|---|
| UI | Qt/QML | **165 QML files, ~15,900 LOC** |
| Business logic | C++ (`core/`) | **~20,100 LOC** |
| Inference engine | `applocal_provider` — standalone C++ binary wrapping **gpt4all-backend → llama.cpp** (nomic-ai fork) | separate process |
| DB | SQLite — 5 tables: `conversation`, `message`, `model`, `pdf`, `pdf_embedding` | — |
| Extras | whisper.cpp (speech-to-text), MarkItDown/Docling (Python doc convert), HuggingFace browse/download, arXiv deep-search + embeddings, local chat server/API, 30+ language syntax highlighters, code generators | — |

## The decisive finding

llama.cpp is **not entangled with Qt**. `core/provider/offlineprovider.cpp`
launches `applocal_provider` as a **`QProcess` subprocess** and talks to it over
**stdin/stdout** with a plain text protocol:

```
__PROMPT__  ...prompt...  __END__   →   ...tokens...  __DONE_PROMPTPROCESS__
```

Engine source: `resources/providers/local_provider/src/main.cpp`
→ `#include <gpt4all-backend/llmodel.h>` (links `llmodel.dll`,
`llamamodel-mainline-kompute.dll`).

**Implication:** a Flutter app can spawn that exact same binary with `dart:io`
`Process` and reuse the identical protocol. Keeping llama.cpp is essentially free.

## `nai_edge_ai` ≠ llama.cpp (important)

`nai_edge_ai` is a mature Flutter package (94 Dart files; services for chat,
vision, audio, embeddings, function calling, clinical NLP) — but it wraps
**`flutter_gemma` → MediaPipe/LiteRT**, uses `.task` models, and is
**mobile-first**. It is **not** llama.cpp and **not** GGUF.

→ Use it as a **reference for Dart service/registry structure**, not as the engine.

## What must be rewritten (the real cost)

Only the inference subprocess is reusable as-is. Everything else is a Dart rewrite:

| Qt/QML Phoenix | Flutter target | Effort |
|---|---|---|
| `view/*.qml` (165) | `lib/presentation/**` | full rewrite |
| `core/conversation`, `core/model` | `lib/services/**` | port logic |
| `core/database` (SQLite) | `sqflite` / `drift` (same schema) | port |
| `core/provider/offline…` | `InferencePort` + `SubprocessEngine` | thin adapter |
| `applocal_provider` binary | **KEEP AS-IS** | ✅ none |
| whisper.cpp / markitdown | subprocess or FFI (same pattern) | wrap |

**Order of magnitude:** multi-month rewrite, not a refactor. The llama.cpp
decoupling removes the single hardest risk; the app surface area is large.

## Recommendation

Take **Path A** (see [01](01-flutter-llama-core.md)): Flutter UI + reuse the
`applocal_provider` subprocess verbatim on desktop; plan FFI for mobile later.
