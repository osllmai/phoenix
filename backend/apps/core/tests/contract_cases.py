"""Route table for the response-contract test: every mounted ninja route, its
sample request, and the status it must answer with."""
from config.api import api

PREFIX = '/api/v1'
JOB_ID = '00000000-0000-0000-0000-000000000000'


def mounted_routes() -> dict:
    out = {}
    for prefix, router in api._routers:
        for path, view in router.path_operations.items():
            template = f"{PREFIX}{prefix.rstrip('/')}{path}"
            for op in view.operations:
                for method in op.methods:
                    out[(method, template)] = op.response_models
    return out


ROUTES = mounted_routes()

PUBLIC = {
    ('GET', '/api/v1/health/'),
    ('GET', '/api/v1/extensions/'),
    ('GET', '/api/v1/extensions/{slug}/'),
}


def cases(d):
    """Every route as an AUTHENTICATED caller sees it. Anonymous rejection of
    everything outside PUBLIC is asserted separately."""
    doc, ext, search, run, lane = d['doc'], d['ext'], d['search'], d['run'], d['lane']
    return [
        ('GET', '/api/v1/health/', '/api/v1/health/', None, 200),
        ('GET', '/api/v1/accounts/me/', '/api/v1/accounts/me/', None, 200),
        ('PATCH', '/api/v1/accounts/me/', '/api/v1/accounts/me/', {'full_name': 'x'}, 200),
        ('POST', '/api/v1/accounts/me/export/', '/api/v1/accounts/me/export/', None, 200),
        ('POST', '/api/v1/ai-chat/deep-search/', '/api/v1/ai-chat/deep-search/',
         {'query': 'transformers'}, 200),
        ('GET', '/api/v1/ai-chat/jobs/{job_id}/', f'/api/v1/ai-chat/jobs/{JOB_ID}/', None, 200),
        ('POST', '/api/v1/deepsearch/', '/api/v1/deepsearch/', {'query': 'vectors'}, 200),
        ('GET', '/api/v1/deepsearch/', '/api/v1/deepsearch/', None, 200),
        ('GET', '/api/v1/deepsearch/{run_id}/', f'/api/v1/deepsearch/{search.id}/', None, 200),
        ('GET', '/api/v1/documents/', '/api/v1/documents/', None, 200),
        ('POST', '/api/v1/documents/', '/api/v1/documents/',
         {'title': 'New', 'source_path': '/new.pdf'}, 200),
        ('GET', '/api/v1/documents/{document_id}/', f'/api/v1/documents/{doc.id}/', None, 200),
        ('GET', '/api/v1/extensions/', '/api/v1/extensions/', None, 200),
        ('GET', '/api/v1/extensions/{slug}/', f'/api/v1/extensions/{ext.slug}/', None, 200),
        ('POST', '/api/v1/extensions/{slug}/install/',
         f'/api/v1/extensions/{ext.slug}/install/', None, 200),
        ('POST', '/api/v1/extensions/{slug}/uninstall/',
         f'/api/v1/extensions/{ext.slug}/uninstall/', None, 200),
        ('GET', '/api/v1/fleet/runs/', '/api/v1/fleet/runs/', None, 200),
        ('POST', '/api/v1/fleet/runs/', '/api/v1/fleet/runs/',
         {'prompt': 'ship it', 'agents': ['claude-code']}, 200),
        ('GET', '/api/v1/fleet/runs/{run_id}/', f'/api/v1/fleet/runs/{run.id}/', None, 200),
        ('POST', '/api/v1/fleet/runs/{run_id}/merge/', f'/api/v1/fleet/runs/{run.id}/merge/',
         {'lane_id': lane.id}, 200),
        ('DELETE', '/api/v1/documents/{document_id}/', f'/api/v1/documents/{doc.id}/', None, 200),
        # last — soft-deletes the caller, after which the token stops authenticating
        ('DELETE', '/api/v1/accounts/me/', '/api/v1/accounts/me/', None, 200),
    ]
