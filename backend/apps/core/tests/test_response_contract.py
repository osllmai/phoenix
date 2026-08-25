"""Response contract for every mounted django-ninja route.

Each route must answer with its declared status AND a body that validates
against its declared ninja schema — a 200 with a wrong-shaped body is a failure.
"""
import typing

import pytest
from django.test import Client
from pydantic import BaseModel, ValidationError, create_model

from apps.deepsearch.models import SearchRun
from apps.documents.models import Document
from apps.extensions.models import Extension
from apps.fleet.models import FleetLane, FleetRun

from .contract_cases import PUBLIC, ROUTES, cases

pytestmark = pytest.mark.django_db


@pytest.fixture(autouse=True)
def eager_celery(settings):
    settings.CELERY_TASK_ALWAYS_EAGER = True
    settings.CELERY_TASK_EAGER_PROPAGATES = True


@pytest.fixture
def client():
    return Client()


@pytest.fixture
def data(user):
    ext = Extension.objects.create(
        slug='contract-doc', name='Contract Doc', publisher='Tester',
        category='document', description='Convert PDFs.', icon='📄',
    )
    doc = Document.objects.create(owner=user, title='Spec', source_path='/spec.pdf')
    search = SearchRun.objects.create(owner=user, query='vectors')
    run = FleetRun.objects.create(owner=user, prompt='contract run')
    lane = FleetLane.objects.create(run=run, agent='claude-code', worktree_path='wt-1')
    return {'ext': ext, 'doc': doc, 'search': search, 'run': run, 'lane': lane}


def _send(client, method, url, payload, headers=None):
    call = getattr(client, method.lower())
    if payload is None:
        return call(url, headers=headers)
    return call(url, data=payload, content_type='application/json', headers=headers)


def _schema_for(models, status):
    model = models.get(status)
    if isinstance(model, type) and issubclass(model, BaseModel):
        return model
    return None


_MIRRORS: dict = {}


def _mirror(schema):
    """A ninja Schema's resolve_* hooks read the ORM object, so it cannot
    re-validate its own serialized body — mirror its fields as plain pydantic."""
    if schema not in _MIRRORS:
        _MIRRORS[schema] = create_model(
            f'{schema.__name__}Contract',
            **{
                name: (field.annotation, ... if field.is_required() else field.default)
                for name, field in schema.model_fields.items()
            },
        )
    return _MIRRORS[schema]


def _check_body(model, body):
    annotation = model.model_fields['response'].annotation
    is_list = typing.get_origin(annotation) is list
    target = typing.get_args(annotation)[0] if is_list else annotation
    if not (isinstance(target, type) and issubclass(target, BaseModel)):
        return

    assert isinstance(body, list if is_list else dict), (
        f'expected a JSON {"array" if is_list else "object"}, got {type(body).__name__}'
    )
    mirror, keys = _mirror(target), set(target.model_fields)
    for row in body if is_list else [body]:
        assert set(row) == keys, f'body keys {sorted(set(row))} != declared {sorted(keys)}'
        mirror.model_validate(row)


def test_every_route_returns_its_declared_contract(client, data, auth_headers):
    failures = []
    for method, template, url, payload, expect in cases(data):
        resp = _send(client, method, url, payload, auth_headers)
        try:
            assert resp.status_code == expect, f'status {resp.status_code}, expected {expect}'
            body = resp.json()
            model = _schema_for(ROUTES[(method, template)], resp.status_code)
            if model is None:
                assert isinstance(body, (dict, list)), 'body is not a JSON object/array'
            else:
                _check_body(model, body)
        except (AssertionError, ValidationError) as exc:
            failures.append(f'{method} {url}: {exc}')
    assert not failures, '\n'.join(failures)


def test_non_public_routes_reject_anonymous(client, data):
    checked = 0
    for method, template, url, payload, _e in cases(data):
        if (method, template) in PUBLIC:
            continue
        resp = _send(client, method, url, payload)
        assert resp.status_code in (401, 403), (
            f'{method} {url} returned {resp.status_code} to an anonymous caller'
        )
        checked += 1
    assert checked == len(ROUTES) - len(PUBLIC)


def test_public_routes_allow_anonymous(client, data):
    for method, template, url, payload, _e in cases(data):
        if (method, template) not in PUBLIC:
            continue
        resp = _send(client, method, url, payload)
        assert resp.status_code == 200, (
            f'{method} {url} returned {resp.status_code} to an anonymous caller'
        )


def test_every_mounted_route_has_a_contract_case(data):
    covered = {(method, template) for method, template, *_ in cases(data)}
    missing = set(ROUTES) - covered
    assert not missing, f'routes with no contract case: {sorted(missing)}'
    assert len(ROUTES) == 22
