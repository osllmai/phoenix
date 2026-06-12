# design/synthetic_data — edge-case JSON fixtures

One folder per app. Deliberately nasty data for UI binding + backend edge tests **before and
after** the API ships: nulls, empty arrays, very long strings, odd/RTL/emoji chars, boundary
numbers, and safety paths (e.g. domain red-flags / critical validations). Folded into `seed_synthetic.py` once
endpoints exist.

## Layout
```
synthetic_data/<app>/<case>.json
```
Cover every state the mocks cover (empty / first-run / error / denied), not just happy path.
