# Phoenix Qt → Flutter — Process Tracker

Master checklist for re-platforming Phoenix to Flutter, keeping llama.cpp.
Status: ☐ not started · ◐ in progress · ☑ done · ⊘ blocked

Design refs: [`scenario/`](scenario/README.md) · [`integration/`](integration/README.md)

## P0 — Decisions & prep (do first)
| ID | Task | Depends | Status |
|----|------|---------|--------|
| 0.1 | Pick engine-on-mobile: subprocess (desktop) vs FFI (mobile) | — | ☐ |
| 0.2 | Pick nai_edge_ai engine approach: dual-engine vs add LlamaCppEngine | — | ☐ |
| 0.3 | Pick backend home: new `phoenix/backend/` vs fold into existing | — | ☐ |
| 0.4 | Pick state mgmt (Riverpod / Bloc) + repo/folder structure | — | ☐ |
| 0.5 | Pin nai_edge_ai ref (`main` vs `feat/clinical-nlp`) | 0.2 | ☐ |
| 0.6 | Create new Flutter project skeleton (desktop targets) | 0.4 | ☑ `app/` (linux/win/mac) |

## P1 — Inference core (keep llama.cpp)
| ID | Task | Depends | Status |
|----|------|---------|--------|
| 1.1 | Define `InferencePort` interface (prompt/stop/load) | 0.6 | ☑ `app/lib/inference/inference_port.dart` |
| 1.2 | `SubprocessEngine`: spawn `applocal_provider`, wire `__PROMPT__/__END__/__DONE__` protocol | 1.1 | ☑ `subprocess_engine.dart` + `protocol.dart` |
| 1.3 | Streaming tokens → Dart Stream (map DONE marker → end) | 1.2 | ☑ verified by test |
| 1.4 | Model load/unload + GPU-layer/param passing | 1.2 | ◐ params block done; unload TODO |
| 1.5 | PoC: generate text end-to-end from Dart | 1.3 | ☑ 3/3 tests pass (mock engine) |
| 1.5b | Build Linux `applocal_provider` binary + run vs real GGUF | 1.5 | ☐ only Win binary exists today |
| 1.6 | (later) `FfiEngine` for mobile (fllama / llama_cpp_dart) | 0.1 | ☐ |

## P2 — Data layer
| ID | Task | Depends | Status |
|----|------|---------|--------|
| 2.1 | Port SQLite schema → sqflite (conversation, message, model done; pdf/pdf_embedding TODO) | 0.6 | ◐ `core/storage/database.dart` |
| 2.2 | Migration/seed + DB init (FFI factory, desktop+test) | 2.1 | ☑ verified via FFI test |
| 2.3 | Repositories (chat done; model/pdf TODO) | 2.1 | ◐ `SqfliteChatRepository` + in-memory fake |

## P3 — Service layer (port of core/)
| ID | Task | Depends | Status |
|----|------|---------|--------|
| 3.1 | ChatService / Conversation / Message (engine + persistence, streaming) | 1.5, 2.3 | ☑ `features/chat/**` + Riverpod providers, 4 tests |
| 3.2 | ModelManager (local catalog, select→engine load, like/remove) | 2.3 | ☑ `features/models/**`, 3 tests |
| 3.3 | HuggingFace browse + download service | 3.2 | ☐ |
| 3.4 | Online providers (API models) | 3.1 | ☐ |
| 3.5 | DeepSearch / arXiv (fetch, tokenizer, embeddings) | 3.1 | ☐ |
| 3.6 | Developer/server + code generators | 3.1 | ☐ |

## P4 — UI rebuild (165 QML → Flutter)
| ID | Task | Depends | Status |
|----|------|---------|--------|
| 4.1 | Component library / design system (46 qml) | 0.6 | ◐ MessageBubble + composer started |
| 4.2 | Chat view (20 qml) | 3.1, 4.1 | ☑ `ChatScreen` + controller, go_router shell, widget test |
| 4.3 | Model views (48 qml) | 3.2, 4.1 | ◐ `ModelsScreen` (list/add/select/like/remove) + route |
| 4.4 | Settings (14 qml) | 4.1 | ☐ |
| 4.5 | DeepSearch / Developer / PDF / Home / Footer / Menu | 3.5, 3.6 | ☐ |
| 4.6 | Theming (port `docs/themes`) | 4.1 | ☐ |

## P5 — Feature extras
| ID | Task | Depends | Status |
|----|------|---------|--------|
| 5.1 | Whisper speech-to-text integration | 3.1 | ☐ |
| 5.2 | Document convert (MarkItDown/Docling) | 3.1 | ☐ |
| 5.3 | Syntax highlighting (30+ langs) | 4.2 | ☐ |
| 5.4 | Embeddings / RAG over PDFs | 2.3, 3.5 | ☐ |

## P6 — nai_edge_ai integration
| ID | Task | Depends | Status |
|----|------|---------|--------|
| 6.1 | Add dependency (path/git) + `NaiEdgeAI.init` smoke test | 0.5 | ☐ |
| 6.2 | Map Phoenix services onto NaiEdgeAI services | 3.1 | ☐ |
| 6.3 | Engine reconciliation (Approach 2: LlamaCppEngine in package) | 0.2, 1.2 | ☐ |
| 6.4 | Reuse clinical/embedding/rag/vision services | 6.2 | ☐ |

## P7 — Local API gateway
| ID | Task | Depends | Status |
|----|------|---------|--------|
| 7.1 | `shelf` server: `/v1/chat/completions` (OpenAI) + SSE | 3.1 | ☐ |
| 7.2 | `/v1/models`, `/v1/embeddings` | 7.1 | ☐ |
| 7.3 | Auth (API key) + 127.0.0.1 default | 7.1 | ☐ |
| 7.4 | Request queue / worker pool (concurrency) | 7.1 | ☐ |

## P8 — Django + Celery backend (full-stack, later)
| ID | Task | Depends | Status |
|----|------|---------|--------|
| 8.1 | DRF project (new or folded) + auth | 0.3 | ☐ |
| 8.2 | `/api/jobs/<id>` async contract | 8.1 | ☐ |
| 8.3 | Celery: deep-search task | 8.2 | ☐ |
| 8.4 | Celery: doc-convert, embeddings, HF sync | 8.2 | ☐ |
| 8.5 | Postgres/pgvector + Beat + Flower | 8.1 | ☐ |

## P9 — CLI
| ID | Task | Depends | Status |
|----|------|---------|--------|
| 9.1 | `phoenix` CLI (`dart compile exe`) over the API | 7.1 | ☐ |
| 9.2 | `/v1/messages` Anthropic adapter (Claude Code) | 7.1 | ☐ |
| 9.3 | llama-server option for tool-facing serving | 6.3 | ☐ |

## P10 — Qt removal & push
| ID | Task | Depends | Status |
|----|------|---------|--------|
| 10.1 | Feature-parity check vs current Phoenix | P4, P5 | ☐ |
| 10.2 | **Delete** `view/` + C++ `core/` outright — Qt preserved in a separate branch. Kept `resources/providers/local_provider/` (llama.cpp engine) | 10.1 | ☑ 409 files removed |
| 10.3 | Remove CMake/Qt build + Qt CI (add Flutter CI later) | 10.2 | ☑ CMakeLists/cmake/release.json/workflows removed |
| 10.4 | Update README/docs, **ready to push** | 10.3 | ☐ |

> **Qt strategy (confirmed):** current Qt/QML + C++ is preserved on a separate
> branch, so the Flutter `main`/`production` can delete it cleanly. No in-repo
> archive folder required. Only `resources/providers/local_provider/` (the
> llama.cpp binary + source) is retained.

## P11 — Quality / release
| ID | Task | Depends | Status |
|----|------|---------|--------|
| 11.1 | Unit + widget tests | P3, P4 | ☐ |
| 11.2 | CI (analyze, test, build matrix) | 10.3 | ☐ |
| 11.3 | Packaging/installers (Win/Mac/Linux) | 11.2 | ☐ |
