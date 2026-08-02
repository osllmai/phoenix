# Phoenix backend — Locust load / pressure test

Hammers the 22 `/api/v1/` django-ninja routes and **validates every response body**, not just the
status code: a `200` with a missing key, a wrong type, or a broken invariant is recorded as a
**failure** in Locust's stats (`response.failure(...)`), so the failure column is a contract report.

The host is never hardcoded — it comes from `--host` (or `LOCUST_HOST`).

## Layout

| File | What |
|------|------|
| `locustfile.py` | entry point — user classes + task weights |
| `checks.py` | `contract()` context manager + type/shape assertions |
| `contracts.py` | expected response shapes, mirrored from the ninja schemas |
| `seed.py` | seeds a shared id pool at test start (no task hardcodes an id) |
| `tasks_read.py` · `tasks_write.py` · `tasks_jobs.py` · `tasks_auth.py` | the tasks |

## Traffic mix

| User class | Weight | Does |
|------------|--------|------|
| `BrowseUser` | 8 | reads only (lists, details, job polls) |
| `WriteUser` | 2 | fan-out, install/uninstall, deepsearch, ai-chat, document create/delete |
| `MergeStormUser` | 1 | nothing but `POST /fleet/runs/{id}/merge/` on the shared seed runs |
| `AccountsUser` | 1 | only defined when `PHOENIX_SESSION_TOKEN` is set |

## Run it

The backend image has no volume mount, so `loadtest/` must be **in the image** — rebuild once:

```bash
cd /home/llmserver/phoenix
docker compose --env-file .env -f docker/local/compose.yml build django
docker compose --env-file .env -f docker/local/compose.yml up -d
```

### Headless (the default run)

```bash
cd /home/llmserver/phoenix
docker compose --env-file .env -f docker/local/compose.yml exec django \
  locust -f loadtest/locustfile.py --host http://localhost:16000 \
  --headless -u 100 -r 10 -t 3m --csv /tmp/phoenix --html /tmp/phoenix.html

docker cp phoenix-django:/tmp/phoenix.html /tmp/phoenix-loadtest.html
```

### Web UI (charts, live tuning) — published on `37090` (phoenix band, extras)

```bash
cd /home/llmserver/phoenix
docker compose --env-file .env -f docker/local/compose.yml run --rm --no-deps \
  -p 37090:8089 django \
  locust -f loadtest/locustfile.py --host http://django:16000 --web-host 0.0.0.0
# open http://localhost:37090
```

### Iterate without rebuilding (bind-mount the suite)

```bash
docker compose --env-file .env -f docker/local/compose.yml run --rm --no-deps \
  -v /home/llmserver/phoenix/backend/loadtest:/app/loadtest django \
  locust -f loadtest/locustfile.py --host http://django:16000 --headless -u 100 -r 10 -t 3m
```

## Env knobs

| Var | Default | Meaning |
|-----|---------|---------|
| `LOCUST_HOST` | — | same as `--host` |
| `PHOENIX_SEED_RUNS` / `PHOENIX_SEED_DOCS` / `PHOENIX_SEED_SEARCHES` | 3 / 3 / 2 | shared rows created at test start |
| `PHOENIX_SESSION_TOKEN` | — | allauth headless token; enables `AccountsUser` (`/accounts/*` is the only authed surface) |
| `PHOENIX_ALLOW_ACCOUNT_DELETE` | — | `1` adds `DELETE /accounts/me/` (soft-deletes the account and kills the token — off by default) |

Minting a token (mandatory email verification, so verify the address first):

```bash
docker compose --env-file .env -f docker/local/compose.yml exec django python manage.py shell -c "
from allauth.account.models import EmailAddress
from apps.accounts.models import User
u, _ = User.objects.get_or_create(email='load@test.local')
u.set_password('LoadTest!2345'); u.save()
EmailAddress.objects.update_or_create(user=u, email=u.email, defaults={'verified': True, 'primary': True})"

curl -s -X POST http://localhost:37000/_allauth/app/v1/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"load@test.local","password":"LoadTest!2345"}' | python3 -m json.tool
# copy meta.session_token, then pass it with:  -e PHOENIX_SESSION_TOKEN=<token>
```

## Reading the failures

These are **real defects the load test is designed to surface**, not test bugs:

- `N winner lanes, expected exactly 1` — `POST /fleet/runs/{id}/merge/` does three unguarded writes
  with no `transaction.atomic()`; concurrent merges of the same run interleave and leave zero or
  several winners. `MergeStormUser` exists to force this.
- `installed=false immediately after install` / `installs_count` — `POST /extensions/{slug}/install/`
  does `update(... F('installs_count') + 1)` then `refresh_from_db()`; a concurrent uninstall between
  the two is a lost update. The `F()` counter itself must never go backwards.
- `full_name/locale not persisted` on `PATCH /accounts/me/` — all `AccountsUser` instances share one
  token, so concurrent patches of the same row race. Run 1–2 users if you want a clean auth signal.

Enqueue endpoints (`/deepsearch/`, `/ai-chat/deep-search/`, `POST /documents/`) only need Redis to be
up; the Celery worker consuming them is optional (jobs just stay `pending`).

`runserver` is a dev server — for throughput numbers that mean anything, run the stack with the
image's gunicorn `CMD` instead.

## Coverage — 22/22 `/api/v1/` routes

health · fleet (list/create/detail/merge) · deepsearch (start/list/detail) · extensions
(list/detail/install/uninstall) · documents (list/detail/create/delete) · ai-chat (deep-search/job
poll) · accounts (me get/patch/export, delete opt-in).

Not exercised: `admin/` and the `_allauth/` identity surface (login is used once, by hand, to mint the
token above).
