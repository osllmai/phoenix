# Phoenix Install + Gateway — Audit Brief

**Purpose:** Independent audit of Phoenix as a **unified local LLM hub**: install like Cursor, serve OpenAI + Anthropic APIs, and configure external clients (Claude CLI, Continue, etc.) to use on-device GGUF models.

**Auditor:** Run this with **Claude CLI** or any reviewer against the repo at the commit/branch under review.

**Repo:** `osllmai/phoenix` · **Branch:** `production` (expected) · **Date:** July 2026

---

## How to run this audit (Claude CLI)

Paste into Claude CLI after pointing it at the repo (or with repo files in context):

```
Read docs/AUDIT.md in the Phoenix repo and perform a full audit.

1. Run: python3 install/verify.py
2. Run: python3 install/phoenix_cli.py configure --show
3. Run: python3 install/install.py --dry-run
4. Read every file listed in §4 "Files to read first"
5. Work through every checkbox in §3
6. Answer every question in §5
7. Fill in the sign-off table in §7 with Pass/Fail and notes

Report: critical bugs first, then gaps, then nits. Be specific — file paths and line references.
```

Or from the repo root in a shell (after `phoenix configure --all` optional):

```bash
cd /path/to/phoenix
python3 install/verify.py
python3 install/phoenix_cli.py configure --dry-run
python3 install/install.py --dry-run
python3 install/phoenix_cli.py configure --show
```

---

## 1. Scope of changes (complete feature set)

| Area | Files | Intent |
|------|-------|--------|
| **Cursor-style install** | `install/install` | `curl -fsSL …/install \| bash` (same UX as Cursor) |
| **Python install (alt)** | `install/install.py` | Same artifacts via `curl … \| python3` |
| **Release build** | `install/build_release.py` | Package CLI + desktop tarballs for CI |
| **Phoenix CLI** | `install/phoenix_cli.py` | `phoenix` · `phoenix serve` · `phoenix configure` |
| **Configure tests** | `install/test_phoenix_cli.py` | Unit tests for env/Continue snippet generation |
| **Verification** | `install/verify.py`, `install/e2e_smoke.py`, `packages/phoenix_server/bin/e2e_serve.dart` | One command runs all tests + live HTTP e2e |
| **OpenAI API** | `packages/phoenix_server/lib/src/completions_api.dart` | `POST /v1/chat/completions` |
| **Anthropic API** | `packages/phoenix_server/lib/src/messages_api.dart` | `POST /v1/messages` (Claude CLI) |
| **Core bridge** | `packages/phoenix_server/lib/src/completion.dart` | Shared engine + model selection |
| **Gateway router** | `packages/phoenix_server/lib/src/models_api.dart`, `bin/server.dart` | Models + both APIs on `:24678` |
| **Unit tests** | `test/completions_api_test.dart`, `test/messages_api_test.dart`, `test/models_api_test.dart` | 18 server tests |
| **CI** | `.github/workflows/release_binaries.yml`, `.github/workflows/phoenix_gateway_ci.yml` | Release artifacts + PR gate |
| **Docs** | `README.md`, this file | User + auditor instructions |

---

## 2. Architecture (expected behavior)

```
                         GitHub Release (on v* tag)
                         ─────────────────────────
curl | bash install  ──► phoenix-cli-{os}-{arch}.tar.gz
                         phoenix-desktop-{os}-{arch}.tar.gz
                         SHA256SUMS

~/.local/bin/phoenix  ──► install/phoenix_cli.py (copied into release bundle)
                            ├─ phoenix serve      → phoenix-server (dart exe)
                            └─ phoenix configure  → ~/.phoenix/env.sh + Continue snippet

phoenix gateway :24678 (loopback)
  GET  /health
  GET  /v1/models
  POST /v1/models / …/select     → load GGUF into engine
  POST /v1/chat/completions      → OpenAI JSON + SSE        → Continue, scripts, etc.
  POST /v1/messages              → Anthropic JSON + SSE     → Claude CLI

External clients (after phoenix configure --all):
  ANTHROPIC_BASE_URL=http://127.0.0.1:24678   → claude
  OPENAI_BASE_URL=http://127.0.0.1:24678/v1   → OpenAI-compatible tools
  ~/.phoenix/continue.phoenix.json            → merge into Continue config
```

**Design constraints (must remain true):**
- Inference on-device only (`phoenix_core` + engine subprocess). Django backend never runs LLMs.
- Gateway binds to **loopback** (`127.0.0.1`) in `bin/server.dart`.
- One loaded model shared by all API clients.

**Explicitly out of scope:**
- Cursor IDE / Cursor Agent CLI integration (separate products, own cloud).
- macOS/Windows engine binaries (Linux-only `linux_llama` today).

---

## 3. Audit checklist

### 3.1 Security

- [ ] `install.py` verifies SHA256 when `SHA256SUMS` is on the release
- [ ] `install.py` uses HTTPS + TLS (`ssl.create_default_context()` + cert path fallbacks)
- [ ] Tar extraction uses `filter="data"` on Python 3.12+ (tar slip mitigation)
- [ ] `install/install` (bash) downloads only from `PHOENIX_DOWNLOAD_BASE` / GitHub releases
- [ ] Gateway binds to loopback, not `0.0.0.0`, in `bin/server.dart`
- [ ] CORS `*` + allowed headers include `x-api-key`, `anthropic-version` — OK for localhost-only?
- [ ] No secrets in repo; `ANTHROPIC_API_KEY=phoenix-local` is a dummy local placeholder
- [ ] `curl | bash` trust model documented (user trusts install URL + GitHub artifacts)
- [ ] `phoenix configure` shell hook append is idempotent (does not duplicate `.phoenix/env` lines)

### 3.2 Gateway — OpenAI (`/v1/chat/completions`)

- [ ] **409** when no model loaded (no `model` field, no prior `/select`)
- [ ] **404** when unknown `model` name
- [ ] **400** when `messages` missing/empty
- [ ] Non-stream: `choices[0].message.content`
- [ ] Stream: SSE `data: {...}` + final `data: [DONE]`
- [ ] Engine errors → **502** (non-stream) or error in stream

### 3.3 Gateway — Anthropic (`/v1/messages`)

- [ ] **409** when no model loaded and no `model` in body
- [ ] **404** when unknown `model` name
- [ ] **400** when `messages` empty or `max_tokens` missing
- [ ] Non-stream: `{ type: message, role: assistant, content: [{type:text,text:…}], stop_reason: end_turn }`
- [ ] Stream: Anthropic SSE events (`message_start`, `content_block_delta`, `message_stop`)
- [ ] Top-level `system` string (and block array) passed to engine
- [ ] Error shape: `{ type: error, error: { type, message } }`

### 3.4 Shared completion logic

- [ ] `CompletionEngine.ensureReady()` auto-selects by model name or requires active model
- [ ] `CompletionEngine.complete()` merges Anthropic `system` param with system-role messages
- [ ] Model switch via `/v1/models/<id>/select` affects both APIs

### 3.5 Installers

- [ ] Bash: `install/install` — detect OS/arch, resolve latest tag, download tarballs, symlink `~/.local/bin/phoenix`
- [ ] Python: `install/install.py` — same artifacts, SHA256 verify, `--cli` / `--desktop` / `--dry-run`
- [ ] Artifact names: `phoenix-{cli|desktop}-{linux|darwin|windows}-{x64|arm64}.tar.gz`
- [ ] Graceful skip when platform artifact missing

### 3.6 Phoenix CLI (`phoenix_cli.py`)

- [ ] `phoenix` / `phoenix serve` starts gateway (source: `dart run`; release: `phoenix-server`)
- [ ] `phoenix configure --all` writes `~/.phoenix/env.sh`, `~/.phoenix/env.fish`, `~/.phoenix/continue.phoenix.json`
- [ ] `phoenix configure --show` / `--dry-run` do not mutate user shell without consent
- [ ] Env vars: `ANTHROPIC_BASE_URL`, `OPENAI_BASE_URL`, `OPENAI_API_BASE`, dummy API keys
- [ ] Shell hook added to `.zshrc` / `.bashrc` / fish `config.fish` only once

### 3.7 Release build + CI

- [ ] `build_release.py` bundles engine on Linux only; `manifest.json` has `"engine": true/false`
- [ ] Release bundle copies `phoenix_cli.py` → `bin/phoenix`
- [ ] `release_binaries.yml` matrix matches installer artifact names
- [ ] Publish job creates GitHub Release if missing, uploads assets
- [ ] `phoenix_gateway_ci.yml` runs `install/verify.py` on PRs

### 3.8 Tests (must pass)

```bash
python3 install/verify.py
```

Expected output ends with: `✓ all verification checks passed`

| Suite | Expected count |
|-------|----------------|
| `packages/phoenix_core` | 41 tests |
| `packages/phoenix_server` | 18 tests |
| `install/test_phoenix_cli.py` | 2 tests |
| `install/e2e_smoke.py` | health, models, select, chat, stream, messages |

---

## 4. Files to read first (priority order)

1. `install/phoenix_cli.py` — CLI + configure
2. `install/install` — Cursor-style bash installer
3. `install/install.py` — Python installer
4. `packages/phoenix_server/lib/src/messages_api.dart` — Anthropic API
5. `packages/phoenix_server/lib/src/completions_api.dart` — OpenAI API
6. `packages/phoenix_server/lib/src/completion.dart` — shared engine bridge
7. `packages/phoenix_server/lib/src/models_api.dart` — router + CORS
8. `packages/phoenix_server/bin/server.dart` — entry point
9. `install/e2e_smoke.py` — end-to-end proof
10. `install/build_release.py` — release packaging
11. `.github/workflows/release_binaries.yml`
12. `.github/workflows/phoenix_gateway_ci.yml`

---

## 5. Review questions for auditor

1. Is the OpenAI response shape enough for Continue, Open WebUI, and common SDKs?
2. Is the Anthropic `/v1/messages` shape enough for **Claude CLI** with `ANTHROPIC_BASE_URL` override?
3. Does streaming for both APIs match what clients expect (SSE formats)?
4. Is `phoenix configure` writing safe, idempotent shell hooks?
5. Race between `tag_and_release.yml` and `release_binaries.yml` on new tags?
6. Should the gateway require auth on non-loopback binds if someone changes the bind address?
7. Is symlink install OK on Windows, or should we ship `.zip` + PATH instructions only?
8. Any gap between README instructions and actual CLI behavior?

---

## 6. Suggested audit commands

```bash
# ── Automated (required) ──
python3 install/verify.py

# ── Configure (read-only) ──
python3 install/phoenix_cli.py configure --show
python3 install/phoenix_cli.py configure --dry-run

# ── Install (read-only; needs network) ──
python3 install/install.py --dry-run
bash -n install/install

# ── Manual gateway smoke (mock engine, no GGUF) ──
cd packages/phoenix_server && dart run bin/e2e_serve.dart &
sleep 2
curl -s http://127.0.0.1:24779/health
kill %1

# ── Diff scope ──
git diff production -- \
  install/ packages/phoenix_server/ docs/AUDIT.md README.md \
  .github/workflows/release_binaries.yml \
  .github/workflows/phoenix_gateway_ci.yml
```

---

## 7. Unified user flow (verify docs match)

```bash
curl -fsSL https://raw.githubusercontent.com/osllmai/phoenix/production/install/install | bash
phoenix configure --all && source ~/.phoenix/env.sh
phoenix   # terminal 1
# terminal 2: register + select model, then:
claude    # or curl /v1/chat/completions / /v1/messages
```

Auditor: confirm README § Quick start matches this flow.

---

## 8. Known limitations (not bugs)

| Limitation | Notes |
|------------|-------|
| macOS/Windows engine | Not built; desktop/cli install without local inference on those platforms |
| Token usage fields | Always `0` in API responses — v1 OK |
| Continue config | Snippet file only; user must merge into `~/.continue/config.json` |
| Public install | Requires GitHub Release with binary artifacts from CI |
| Short URL | `get.phoenix.example/install` — user must host; raw GitHub URL works interim |
| Cursor IDE | Cannot use Phoenix as backend |

---

## 9. Sign-off template

| Check | Pass/Fail | Notes |
|-------|-----------|-------|
| `install/verify.py` green | | |
| Security (§3.1) | | |
| OpenAI API (§3.2) | | |
| Anthropic API (§3.3) | | |
| Installers (§3.5) | | |
| `phoenix configure` (§3.6) | | |
| CI workflows (§3.7) | | |
| README accurate (§7) | | |
| **Overall — safe to merge?** | | |

---

## 10. Claude CLI audit prompt (copy-paste)

```
You are auditing the Phoenix local LLM hub changes. Read docs/AUDIT.md fully.

Execute every command in §6 that you can run safely.
Read every file in §4.
Complete §3 checklists and §9 sign-off.
Answer §5 review questions.

Output format:
1. Executive summary (2–3 sentences)
2. Test results (paste verify.py outcome)
3. Findings (Critical / Major / Minor)
4. Sign-off table (§9 filled in)
5. Recommended follow-ups before production release
```

---

*Last updated: unified install + OpenAI + Anthropic APIs + phoenix configure. File findings as GitHub issues or PR comments.*
