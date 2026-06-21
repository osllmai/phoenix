# 04 — CLI + connecting external agents (Claude Code) to GGUF

A CLI is just **another client of the local API**. The trick to connecting an
external agentic CLI (Claude Code, etc.) is **API-shape compatibility**: serve the
wire format those tools already speak, backed by your GGUF model.

## Architecture (CLIs added)

```
   CLIENTS ────────────────────────────────────────────────────────────
   ┌────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
   │ Flutter UI │  │  phoenix CLI │  │ Claude Code  │  │ any OpenAI    │
   │            │  │ (your own,   │  │ (3rd-party   │  │ SDK / curl /  │
   │            │  │  Dart exe)   │  │  agentic CLI)│  │ LangChain     │
   └─────┬──────┘  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘
         │                │                 │                 │
         │ HTTP/WS        │ HTTP            │ ANTHROPIC_BASE  │ OPENAI_BASE
         │                │                 │ _URL=localhost  │ _URL=localhost
         └────────────────┴────────┬────────┴─────────────────┘
                                   ▼
   ╔═══════════════════════════════════════════════════════════════════╗
   ║              LOCAL API GATEWAY   (one local port)                  ║
   ║   /v1/chat/completions   ← OpenAI-compatible  (most tools)         ║
   ║   /v1/messages           ← Anthropic-compatible (Claude Code)      ║
   ║   /v1/models  /v1/embeddings   · SSE streaming · token auth        ║
   ╚════════════════════════════════┬══════════════════════════════════╝
                                    ▼
                  ┌──────────────────────────────────────┐
                  │  llama.cpp serving GGUF              │
                  │  (llama-server  OR  applocal_provider)│
                  │  ✓ offline   ✓ GPU detect   ✓ GGUF   │
                  └──────────────────────────────────────┘
```

## Connecting Claude Code to local GGUF

Claude Code talks to the **Anthropic Messages API** (`/v1/messages`) and allows an
endpoint override:

```bash
ANTHROPIC_BASE_URL=http://localhost:24678 \
ANTHROPIC_API_KEY=local-dummy \
claude
```

Every request now hits **your** local server. The gateway translates
`/v1/messages` ⇄ llama.cpp and streams GGUF tokens back. Claude Code never knows
it isn't talking to Anthropic.

## Two ways to provide `/v1/messages` (both keep llama.cpp)

| Option | What it is | Best for |
|---|---|---|
| **A. llama-server + proxy** | Run `llama-server` (ships with llama.cpp, **already OpenAI-compatible** for GGUF) + a thin **Anthropic⇄OpenAI translator** in front | Fastest, least code |
| **B. Native gateway** | Your Dart/Django gateway exposes both `/v1/chat/completions` *and* `/v1/messages` over `InferencePort` | Full control, one process |

**Best practice:** use **`llama-server`** for anything CLI/tool-facing. Still
llama.cpp (keeps GGUF), but natively speaks the OpenAI API — so the OpenAI half is
nearly free and you only write the small Anthropic-shape adapter.

## Where each CLI plugs in

```
  phoenix CLI   ──►  native protocol or /v1/chat/completions   (full control)
  OpenAI tools  ──►  /v1/chat/completions                      (works as-is)
  Claude Code   ──►  /v1/messages   (Anthropic shape — needs adapter/proxy)
```

## The `phoenix` CLI (your own)

Build as a **thin client of the API**, not a second engine:

```
  $ phoenix chat "explain this repo"        # one-shot
  $ phoenix run --model qwen2.5-coder.gguf  # pick GGUF
  $ phoenix serve                           # start the local gateway
  $ cat file.py | phoenix ask "find bugs"   # pipe / agentic
```

Compile with `dart compile exe` → single static binary, **reuses the same service
layer** as the Flutter app. Zero engine duplication.

## Honest caveat

You *can* point Claude Code at a local GGUF model, but agentic coding CLIs are
tuned for frontier models — strong tool-calling, long context, tight
instruction-following. A small GGUF (7B–14B) connects and responds, but tool-use
loops and multi-step edits will be weaker/flakier. Works best with large
coder-tuned GGUFs (e.g. Qwen2.5-Coder-32B), and even then expect a quality gap.
For the *own* `phoenix` CLI you control the prompts, so you can tune the agent
loop to what local models actually do well.

## Smallest useful next step

Scaffold the gateway with **both** `/v1/chat/completions` and a minimal
`/v1/messages` adapter (so Claude Code connects), wired to `llama-server`.
