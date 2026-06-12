# design/api-endpoint — captured real-JSON response catalog

Real responses captured from the live API (seed login), one folder per app. Examples for UI
binding + docs — distinct from `scenario/` (human contract) and `contract/` (typed schema).

## Layout
```
api-endpoint/<app>/_SPEC.md          # how this app's catalog was captured (auth, endpoints)
api-endpoint/<app>/<endpoint>.json   # captured response body
```

Capture against the seed user from the pipeline Config block. Re-capture when a contract changes.
