# <app> — build plan

> Plans describe the full *intended* build, not what's shipped. Verify against code + `PROGRESS.md`.

## Screens covered
Which mock → which phase (mobile is source of truth). Format: `screen` → `m-/T-/D-/x-` → phase NN.

| Screen | Mocks | Phase |
|--------|-------|-------|
| _example_ | m-, T-, D-, x- | 01 |

## Phases
| # | Phase | State | Notes |
|---|-------|-------|-------|
| 01 | Scaffold & models | ⬜ | — |
| 02 | Features | ⬜ | — |
| 03 | Query-performance (N+1 budget) | ⬜ | — |
| 04 | Integration-hardening (auth/scoping/throttle/audit) | ⬜ | — |
| 05 | Frontend wiring (web) | ⬜ | — |
| 06 | Flutter wiring (mobile) | ⬜ | — |
| 07 | Extension wiring (WXT) | ⬜ | — |

## Status board
Current phase + blockers. Update on every commit; never leave stale.

## Working agreement
≤200 lines/file (refactor at 150), functions ≤50. All endpoints `auth=JWTBearer()`, scoped by
`user`/`tenant`. DB change → migration same change. `assertNumQueries` budget test per feature.
One contract (`design/scenario/`) + tokens (`design/pattern/`) + types (`design/contract/`) feed
all surfaces — never duplicate.
