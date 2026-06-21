# phoenix_core

Phoenix's on-device LLM core — **pure Dart, no Flutter**. The engine (llama.cpp
subprocess), chat + model services, and SQLite persistence sit behind a single
`PhoenixCore` facade. Consumed in-process by the Flutter UI, the HTTP gateway,
and the CLI.

> Golden rule: inference is on-device and the engine stays llama.cpp. The
> `InferencePort` abstraction lets a future FFI/mobile backend drop in without
> touching any caller.

## Quick start

```dart
final core = await PhoenixCore.open(
  dbPath: '/data/phoenix.db',
  databaseFactory: databaseFactoryFfi,          // sqflite native on mobile
  enginePath: 'engine/local_provider/applocal_provider',
);

final model = await core.models.addLocal(name: 'Llama', path: '/m.gguf');
await core.models.select(model);                 // loads it into the engine

final conv = /* a persisted Conversation */;
await for (final token in core.chat.send(conv, 'Hello')) {
  stdout.write(token);
}
await core.dispose();
```

## Layout (`lib/src/`)

- `engine/` — `InferencePort` (the contract) · `SubprocessEngine` (llama.cpp over
  stdin/stdout) · `protocol.dart` (wire markers) · `wire_guard.dart`,
  `stdout_router.dart`, `stderr_buffer.dart`, `engine_exceptions.dart`
- `chat/` — `ChatService`, `Message`, `Conversation`, repositories
- `models/` — `ModelManager`, `AiModel`, repositories
- `storage/` — `PhoenixDatabase` (legacy-compatible SQLite schema)

## The engine port

Services depend **only** on `InferencePort`. Today it is backed by
`SubprocessEngine` (reuses the existing `applocal_provider` binary, isolating
crashes/GPU/memory in a child process); a future `FfiEngine` for iOS/Android can
drop in unchanged. See `design/scenario/01-flutter-llama-core.md`.

### Hardened behavioral contracts

| # | Contract |
|---|----------|
| S1 | `stop()` ends the stream once the engine acks (`__DONE__`); no hang |
| S2 | a reentrant `prompt()` while generating throws `StateError` |
| S3 | a process crash mid-generation surfaces `EngineException(crash)` |
| S4 | `loadModel`/`models.select` switches models (kill + reap + respawn) |
| S5 | prompt/param content that would collide with the wire protocol is rejected |
| S6 | engine errors (stderr / non-zero exit) surface as a typed `EngineException` |
| S7 | a cut-short turn persists the partial response with `status: aborted` |
| S8 | after `stop()`, the next prompt streams only its own tokens (no bleed) |

Tunables are injected, never hardcoded: `SubprocessEngine(loadTimeout:,
stopTimeout:)`, `StderrBuffer(max:)`. The package reads no `.env` — the host app
owns configuration and passes it in.

## Test

```bash
cd packages/phoenix_core && dart pub get && dart test   # 28 tests, headless (FFI)
dart analyze                                             # 0 issues
```

Engine tests drive the real protocol against `test/mock_engine.dart`, a stand-in
that speaks `__PROMPT__/__END__/__DONE_PROMPTPROCESS__/__STOP__`.
