# design/contract — the typed contract (one schema → every surface)

The **machine-readable** API contract. Complements (does not replace) `scenario/` (human md) and
`api-endpoint/` (captured example JSON). This is the seam that kills model duplication: **one
schema generates every surface's types — never hand-write request/response models.**

## Source
django-ninja already emits OpenAPI. Capture it (do not author by hand):
```
GET /api/v1/openapi.json  →  design/contract/openapi.v1.json
```
Re-capture whenever an endpoint changes; commit the diff.

## Codegen (outputs land in design/contract/generated/, then are imported by code)
| Surface | From | Generated |
|---------|------|-----------|
| web | `openapi.v1.json` | TS types + zod schemas (e.g. **Orval** / **Kubb** / **hey-api** — emit zod for runtime validation) → shared pkg `@<scope>/contracts` |
| **extension** (WXT) | same | **reuses `@<scope>/contracts`** — no Next code, no copied client |
| flutter | same | Dart models (e.g. `openapi-generator` dart-dio / `swagger_parser`) → `mobile/lib/core/contract/` |

## Rule
- `generated/` is derived — **never hand-edit**. Each surface adds only its own fetch + **auth
  adapter** (web = HttpOnly cookies · extension = WXT `storage` token + `host_permissions`
  · flutter = Dio), around the **shared** types/schemas.
- Backend stays the authority: the contract is generated *from* it, not maintained beside it.
