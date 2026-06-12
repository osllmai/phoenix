# Phoenix Backend

Django + django-ninja + Celery (mirrors the `health` backend layout).

**Role:** cloud/async surface only — auth, model catalog, sync, and long-running
jobs (deep-search, doc-convert, embeddings) via Celery. **LLM inference does NOT
run here** — it stays on-device (llama.cpp). See
[`../design/scenario/03-django-celery-hybrid.md`](../design/scenario/03-django-celery-hybrid.md).

## Layout
```
backend/
├── manage.py
├── config/            settings/ · api.py (ninja) · celery.py · urls · wsgi/asgi
├── apps/
│   ├── core/
│   └── ai_chat/       api.py (router) · tasks.py (Celery) · models.py
├── common/
└── tests/
```

## Status
Scaffold (P8). Endpoints: `GET /api/v1/health/`, `POST /api/v1/ai-chat/deep-search/`,
`GET /api/v1/ai-chat/jobs/<id>/`. Wire up real tasks per the tracker.
