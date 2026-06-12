# 01 — Flutter UI + keep llama.cpp (Path A)

The core scenario: rebuild the UI and logic in Flutter, but keep the existing
llama.cpp engine binary and talk to it through a single Dart abstraction.

## Target architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         FLUTTER APP (Dart)                            │
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────┐     │
│  │  PRESENTATION  (widgets / screens)                          │     │
│  │  chat · models · settings · deepsearch · developer · pdf    │     │
│  └───────────────────────────┬─────────────────────────────────┘     │
│                              │ (Riverpod / Bloc state)               │
│  ┌───────────────────────────▼─────────────────────────────────┐     │
│  │  SERVICE LAYER  (pure Dart — port of core/, no Qt)          │     │
│  │  ChatService   ModelManager   DownloadService   DeepSearch  │     │
│  │  Conversation  HuggingFace     Embeddings        Whisper    │     │
│  └──────┬───────────────────┬────────────────────┬─────────────┘     │
│  ┌──────▼──────┐    ┌───────▼────────┐   ┌───────▼──────────┐        │
│  │  sqflite /  │    │  InferencePort │   │  dart:io / http  │        │
│  │  drift (DB) │    │  (abstraction) │   │  downloads, API  │        │
│  └─────────────┘    └───────┬────────┘   └──────────────────┘        │
└──────────────────────────────┼──────────────────────────────────────┘
                              │   ◄── SAME stdin/stdout text protocol
                              │       __PROMPT__ / __END__ / __DONE…__
            ┌─────────────────▼──────────────────┐
            │   applocal_provider  (UNCHANGED)    │  ← KEEP. archive nothing here
            │   gpt4all-backend → llama.cpp       │
            │   GGUF models, GPU detect, Kompute  │
            └────────────────────────────────────┘
```

## The `InferencePort` abstraction (the whole trick)

One Dart interface, two implementations. Services depend **only** on the
interface, never on a concrete engine.

```
                  ┌──────────────────────┐
                  │   InferencePort      │   ← abstract interface
                  │  prompt() · stop()   │     (services depend ONLY on this)
                  └──────────┬───────────┘
              ┌──────────────┴───────────────┐
   ┌──────────▼──────────┐        ┌───────────▼─────────────┐
   │  SubprocessEngine   │        │  FfiEngine (later)      │
   │  dart:io Process    │        │  fllama / llama_cpp_dart│
   │  → applocal_provider│        │  → libllama (in-proc)   │
   │  ✓ DESKTOP today    │        │  ✓ iOS / Android        │
   └─────────────────────┘        └─────────────────────────┘
```

- **Desktop ships day one** by reusing the existing binary.
- **Mobile drops in later** via FFI — UI and services don't change, they only
  know `InferencePort`.

## Layering rule

Dependencies point **downward only**: `UI → Service → InferencePort → engine`.
The UI never calls the engine directly. This mirrors how `nai_edge_ai` is already
built (`NaiEdgeAI` orchestrator → services → `flutter_gemma`); here we swap
`flutter_gemma` for `InferencePort`.

## Why keep the process boundary on desktop

Do **not** link llama.cpp into the Flutter process on desktop. The subprocess
already isolates crashes, GPU drivers, and memory — that is a feature. Inherit it
for free. (On mobile there is no subprocess option, hence FFI.)

## Mapping cheat-sheet

```
  view/*.qml (165)         →  lib/presentation/**     (full rewrite)
  core/conversation, model →  lib/services/**         (port logic, Dart)
  core/database (SQLite)   →  sqflite / drift         (same schema)
  core/provider/offline…   →  InferencePort + SubprocessEngine
  applocal_provider binary →  KEEP AS-IS  ✅
  whisper.cpp / markitdown →  subprocess or FFI (same pattern)
```

## Proof-of-concept next step

Scaffold `InferencePort` + `SubprocessEngine` against the real
`__PROMPT__/__END__/__DONE_PROMPTPROCESS__` protocol → smallest runnable spine.
