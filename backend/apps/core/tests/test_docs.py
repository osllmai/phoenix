"""Docs UI is Scalar, served from first-party assets, with the Agent off."""
import pytest
from django.test import Client

pytestmark = pytest.mark.django_db


@pytest.fixture
def client():
    return Client()


def test_docs_page_is_scalar_with_first_party_assets(client):
    html = client.get('/api/v1/docs').content.decode()

    assert 'Scalar.createApiReference' in html
    assert 'swagger' not in html.lower()
    assert '/scalar/standalone.js' in html
    assert '/scalar/favicon.svg' in html
    for third_party in ('jsdelivr', 'django-ninja.dev', 'proxy.scalar.com'):
        assert third_party not in html


def test_docs_page_disables_the_paid_agent(client):
    html = client.get('/api/v1/docs').content.decode()

    assert '"agent": {"disabled": true}' in html
    assert '"key"' not in html


def test_scalar_bundle_is_served(client):
    response = client.get('/scalar/standalone.js')

    assert response.status_code == 200


def test_openapi_schema_still_advertises_the_session_token_header(client):
    schema = client.get('/api/v1/openapi.json').json()

    assert schema['paths']['/api/v1/health/']
    assert schema['components']['securitySchemes']['SessionTokenAuth'] == {
        'type': 'apiKey', 'in': 'header', 'name': 'X-Session-Token',
    }
