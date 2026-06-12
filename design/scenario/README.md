# Phoenix → Flutter Migration — Design Scenarios

Working notes for re-platforming **Phoenix** (today: Qt/QML + C++ desktop app)
onto Flutter while **keeping llama.cpp** as the inference engine, and growing it
into a backend + CLI ecosystem.

These docs capture the audit and the architecture options discussed. They are
**design intent**, not committed work.

## The one-line idea

> Archive `view/` (QML UI) and most of `core/` (C++ logic), rebuild them in
> Flutter/Dart. **Keep `resources/providers/local_provider/` (llama.cpp) untouched**
> and put one thin Dart adapter (`InferencePort`) in front of it.

## Documents

| # | Doc | Question it answers |
|---|---|---|
| 00 | [audit.md](00-audit.md) | Is a full Flutter rewrite feasible? What is reusable? |
| 01 | [flutter-llama-core.md](01-flutter-llama-core.md) | How does Flutter keep llama.cpp? (`InferencePort`) |
| 02 | [local-backend-api.md](02-local-backend-api.md) | Expose the engine as a local API so other apps can use it |
| 03 | [django-celery-hybrid.md](03-django-celery-hybrid.md) | Where Django + Celery fit (cloud/async jobs) |
| 04 | [cli-and-gguf-tooling.md](04-cli-and-gguf-tooling.md) | A `phoenix` CLI + connecting Claude Code to GGUF |

## Key decisions still open

- **Engine on mobile:** subprocess (desktop) vs FFI (`fllama`/`llama_cpp_dart`) — see 01.
- **Backend home:** new `phoenix/backend/` Django service vs fold into existing
  (`nai-integrations` / `health`) — see 03.
- **CLI-facing engine:** `llama-server` (native OpenAI API) vs custom gateway — see 04.
- **Relationship to `nai_edge_ai`:** reference for Dart service structure only;
  it wraps `flutter_gemma` (MediaPipe), **not** llama.cpp — see 00.
