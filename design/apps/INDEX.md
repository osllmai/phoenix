# INDEX — apps → phases

Per-app phase list. Links to each app's board + phase specs. See `PROGRESS.md` for the roll-up.

Spine (from `_TEMPLATE/`): `01 scaffold/models → 02… features → query-performance →
integration-hardening → frontend-wiring (web) → flutter-wiring (mobile) → extension-wiring (WXT)`.
Thin/infra apps collapse phases that are N/A (noted in each README).

| App | # | Phase spine (first → last) | Board |
|-----|:-:|----------------------------|-------|
| [core](core/README.md) | 2 | solidify-engine-port → verify-and-board | `core/README.md` |
| [chat](chat/README.md) | 10 | scaffold → extension-wiring | `chat/README.md` |
| [models](models/README.md) | 9 | scaffold-local-catalog → extension-wiring | `models/README.md` |
| [deepsearch](deepsearch/README.md) | 9 | scaffold → extension-wiring | `deepsearch/README.md` |
| [developer](developer/README.md) | 11 | scaffold → extension-wiring | `developer/README.md` |
| [documents](documents/README.md) | 10 | scaffold → extension-wiring | `documents/README.md` |
| [speech](speech/README.md) | 9 | scaffold → extension-wiring | `speech/README.md` |
| [settings](settings/README.md) | 7 | scaffold-store → extension-wiring | `settings/README.md` |
| [home](home/README.md) | 9 | scaffold-shell → extension-wiring | `home/README.md` |
| [welcome](welcome/README.md) | 4 | scaffold-first-run-gate → consent-finish-home | `welcome/README.md` |
| [extensions](extensions/README.md) | 10 | scaffold → extension-wiring | `extensions/README.md` |
| [accounts](accounts/README.md) | 8 | scaffold-user-model → flutter-wiring-mobile | `accounts/README.md` |
| [auth](auth/README.md) | 8 | scaffold → flutter-wiring | `auth/README.md` |
| [billing](billing/README.md) | 8 | scaffold-stripe-webhook → flutter-wiring | `billing/README.md` |
| [teams](teams/README.md) | 9 | scaffold-org-membership → flutter-wiring | `teams/README.md` |
| [notifications](notifications/README.md) | 8 | scaffold → flutter-wiring | `notifications/README.md` |

**Totals:** 16 apps · 129 phase specs. `core` is the only built app (engine port);
the other 15 are design-complete plans (⬜ not started). Backend-led apps
(accounts · auth · billing · teams · notifications) have no UI mocks and skip
extension-wiring; on-device apps note where query-performance / backend phases are N/A.
