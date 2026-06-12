# Integration — `nai_edge_ai`

Bring the in-house Flutter package `nai_edge_ai` into the new Phoenix Flutter app
as its **service layer**. This is the first integration step after the Qt→Flutter
conversion.

- **Repo:** `https://github.com/nemati-ceo/nai_edge_ai.git` (private)
- **Active branch:** `feat/clinical-nlp` · base `main`
- **Engine it ships with:** `flutter_gemma` → MediaPipe/LiteRT (**not** llama.cpp)

## Sequence (per current plan)

```
  1. Convert ALL of Phoenix to Flutter, strip Qt/QML/C++ UI   → ready to push
  2. Full-stack process  (to be defined later)
  3. ► Fetch + wire nai_edge_ai   ◄  YOU ARE HERE
```

## How to fetch it

**Option A — git dependency (recommended for shared use):**

```yaml
# phoenix (Flutter) pubspec.yaml
dependencies:
  nai_edge_ai:
    git:
      url: https://github.com/nemati-ceo/nai_edge_ai.git
      ref: main          # or feat/clinical-nlp while clinical work lands
```

**Option B — path dependency (local co-development):**

```yaml
dependencies:
  nai_edge_ai:
    path: ../nai_edge_ai     # /home/llmserver/nai_edge_ai
```

Use **path** while iterating on both repos together; switch to **git ref** (pinned
commit/tag) for reproducible pushes.

## What it gives Phoenix (public API)

Single orchestrator `NaiEdgeAI` + services:

```
  NaiEdgeAI.init(config) / prepare / downloadModel / isModelReady / dispose
  NaiEdgeAI.inference   chat   audio   vision   embedding   functions
            thinking    noteChat   ragChat   hybrid   clinical/ner/deid
            modelManager   device   connectivity   nematiApi
```

Usage:

```dart
import 'package:nai_edge_ai/nai_edge_ai.dart';

await NaiEdgeAI.init(NaiEdgeConfig(
  model: NaiModels.findById('gemma3-270m')!,
  features: {NaiFeature.textGen, NaiFeature.chat},
));
final text = await NaiEdgeAI.inference.generate('Hello');
```

This maps onto most of Phoenix's old `core/` services (chat, embeddings, RAG,
model manager) — so adopting it removes a large slice of the rewrite from
[`../scenario/00-audit.md`](../scenario/00-audit.md).

## ⚠️ The engine reconciliation (must decide)

`nai_edge_ai` runs **flutter_gemma (MediaPipe, `.task` models)**. Phoenix's mandate
is **keep llama.cpp / GGUF**. These are two different engines. Three ways to
reconcile:

| Approach | What it means | Trade-off |
|---|---|---|
| **1. Dual engine** | Use nai_edge_ai's services for flutter_gemma models **and** keep the llama.cpp subprocess (`InferencePort`) for GGUF, side by side | Most flexible; two engines to maintain |
| **2. Add llama.cpp backend INTO nai_edge_ai** | Introduce an engine abstraction in nai_edge_ai; implement a `LlamaCppEngine` (subprocess/FFI) behind the same services | Cleanest long-term; **requires a PR to nai_edge_ai** |
| **3. flutter_gemma only** | Drop llama.cpp, use nai_edge_ai as-is | Contradicts the "keep llama.cpp" mandate ❌ |

**Recommendation: Approach 2.** nai_edge_ai already hides its engine behind a
service layer (services call `flutter_gemma`, not the app). Add an engine port so
those same services can run on **either** flutter_gemma **or** llama.cpp/GGUF —
then Phoenix gets the rich service catalog *and* keeps GGUF. This is the same
`InferencePort` idea from [`../scenario/01-flutter-llama-core.md`](../scenario/01-flutter-llama-core.md),
pushed down into the package.

```
        Phoenix (Flutter UI)
                │
                ▼
        NaiEdgeAI services  (chat, embed, rag, vision …)
                │
        ┌───────┴─────────────┐   ← new engine abstraction inside nai_edge_ai
        ▼                     ▼
  flutter_gemma          LlamaCppEngine
  (MediaPipe/.task)      (applocal_provider / llama-server, GGUF)
```

## Open decisions

- **Ref to pin:** `main` vs `feat/clinical-nlp` (clinical NLP not yet merged).
- **Engine approach:** 1 (dual) vs 2 (add llama.cpp backend to the package).
- **Model formats supported at launch:** GGUF only, or GGUF + `.task`.

## Next step

Stand up a throwaway Flutter app that depends on `nai_edge_ai` (path dep) and runs
`NaiEdgeAI.inference.generate(...)` on a flutter_gemma model — proves the wiring —
then prototype the `LlamaCppEngine` port (Approach 2).
