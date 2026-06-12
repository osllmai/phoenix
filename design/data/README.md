# design/data — raw sourcing → seed pipeline

Real reference/lookup data that becomes seed content. Distinct from `synthetic_data/` (edge-case
fixtures). Clean three-stage layout:

```
data/raw/        # untouched source dumps (CSV/JSON from upstream)
data/scripts/    # transform/dedupe/normalize → catalog
data/catalog/    # versioned, app-ready JSON (e.g. foods.v1.json) — consumed by seed commands
```

Large catalogs are served from object storage (e.g. R2 CDN) in prod; `catalog/` holds the
versioned source. Seed via the backend's `seed_*` management commands.
