# design/pattern — design-system SSOT (tokens + the canonical pattern library)

Read this **first** and build to it. Reuse/match the established UI · component · code ·
architecture patterns; never reinvent or hardcode a one-off. Save new reusable patterns **back**.

## Tokens — the single source
Edit only `tokens/*.json`; everything else is **generated** (never hand-edit `generated/`).

```
tokens/{meta,color,color-extra,typography,layout,effect}.json
   └─ build_tokens.py
        ├─ emit_css.py   → generated/tokens.web.css   (web globals.css + EXTENSION reuse) + tokens.mock.css (mocks)
        ├─ emit_dart.py  → generated/app_tokens.g.dart (Flutter)
        └─ verify_fidelity.py  (mechanical check: generated matches source)
```

Generated CSS var names: `--bg-*`, `--surface-*`, `--border-*`, `--text-*`, `--accent-*`,
`--fs-*`, `--fw-*`, `--lh-*`, `--ls-*`, `--sp-*`, `--r-*`, `--dur-*`, `--ease-*`, `--shadow-*`.

## Anti-duplication
- **One token source** → web + extension share `tokens.web.css`; Flutter uses `app_tokens.g.dart`.
- Mocks use `tokens.mock.css` (CSS vars only, no hex).
- If the generators don't exist yet, this scaffold leaves the contract above; copy real
  `build_tokens.py` / `emit_*.py` / `verify_fidelity.py` from a reference `pattern/`, or add them.
