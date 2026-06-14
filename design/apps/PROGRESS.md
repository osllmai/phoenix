# PROGRESS — roll-up board (start here for "where are we")

Branch: `app/models` (core merged-ready on `app/core`) · Updated: `2026-06-14`. Rolled up from `design/apps/<app>/README.md`.

State: ✅ shipping · 🟨 partial · ⬜ not started · 🚫 blocked. Wiring-ready feeds web/flutter/extension.

**This pass:** build-plan docs authored for **all 16 apps** — `README.md` + phase specs
following `_TEMPLATE/` (15 apps × 4–11 phases, fanned out one agent per app). `core` is the
only app with code; the other 15 are design-complete (⬜ not started). **129 phase specs total.**

| App | Phases (done/total) | State | Wiring ready? | Top blocker / notes |
|-----|----------------------|-------|---------------|---------------------|
| core | 2/2 | ✅ | 🟢 | engine port complete: 30 tests green, audits + docs + ADRs done; ready to consume |
| chat | 0/10 | ⬜ | 🟨 | consumes `phoenix_core` chat spine; backend role = optional cloud sync only |
| models | 0/9 | 🟨 | 🟨 | IN PROGRESS (app/models): on-device Flutter local-catalog slice; backend/web/extension/HF-cloud deferred |
| deepsearch | 0/9 | ⬜ | 🟨 | RAG via sqlite-vec/pgvector; web-search provider unpinned (`.env`) |
| developer | 0/11 | ⬜ | 🚫 | the paid power layer (Maestro/Flows/Evaluators); desktop-only exec, mobile remote-monitor |
| documents | 0/10 | ⬜ | 🟨 | Docling convert as Celery backend job; on-device RAG = sqlite-vec |
| speech | 0/9 | ⬜ | 🟨 | Whisper on-device (small) / Celery backend (large) → chat composer |
| settings | 0/7 | ⬜ | 🟨 | on-device SQLite store; query-perf + backend hardening marked N/A |
| home | 0/9 | ⬜ | 🟨 | aggregator (no own DB/endpoints); reads developer runs + `news.json` |
| welcome | 0/4 | ⬜ | 🟨 | thin first-run wizard; starter-model download depends on `models` |
| extensions | 0/10 | ⬜ | 🟨 | marketplace over FeatureModule registry; paid take-rate via `billing` |
| accounts | 0/8 | ⬜ | 🟨 | cloud identity (Postgres); records-vs-ceremonies split with `auth` |
| auth | 0/8 | ⬜ | 🚫 | login/JWT + gateway API-key + phone↔desktop pairing; blocks JWTBearer everywhere |
| billing | 0/8 | ⬜ | 🟨 | Stripe foundation + Pro + IndoxHub usage + marketplace payouts |
| teams | 0/9 | ⬜ | 🟨 | enterprise (seats/RBAC/SSO/shared/audit); seats consume `billing` |
| notifications | 0/8 | ⬜ | 🟨 | in-app inbox + push; cross-app dispatch via `core.registry` hook |

**Totals:** 1 partial · 15 not-started · 0 shipping. 129 phase specs authored (design only).

## Critical path

`auth` (JWTBearer + gateway api-key + pairing) and `accounts` (user records) underpin every
cloud/teams feature — build them before billing/teams. On-device apps (chat/models/settings/
speech/documents on desktop) can proceed against `phoenix_core` without the backend. `developer`
is the paid wedge and the largest app (11 phases) — sequence after the core surfaces land.

<!-- One row per app. A phase ships only when migrations apply, tests green, ruff clean. -->
