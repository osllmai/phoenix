"""Expected response shapes, mirrored 1:1 from the django-ninja schemas."""
from __future__ import annotations

from checks import NUM

HEALTH = {'status': str, 'service': str}

LANE = {
    'id': int,
    'agent': str,
    'role': str,
    'worktree_path': str,
    'state': str,
    'status_label': str,
    'summary': str,
    'additions': int,
    'deletions': int,
    'files_changed': int,
    'elapsed': str,
    'route': str,
    'cost': str,
    'is_winner': bool,
}

EVENT = {'at': str, 'actor': str, 'text': str, 'outcome': str}

RUN_LIST = {
    'id': int,
    'prompt': str,
    'base_branch': str,
    'race_mode': bool,
    'status': str,
    'created_at': str,
    'lane_count': int,
    'done_count': int,
}

RUN_DETAIL = {
    'id': int,
    'prompt': str,
    'base_branch': str,
    'race_mode': bool,
    'status': str,
    'created_at': str,
    'lanes': list,
    'events': list,
}

EXTENSION_LIST = {
    'id': int,
    'slug': str,
    'name': str,
    'publisher': str,
    'category': str,
    'icon': str,
    'version': str,
    'verified': bool,
    'rating': NUM,
    'installs_count': int,
    'installed': bool,
}

EXTENSION_DETAIL = dict(EXTENSION_LIST, description=str, created_at=str)

DOCUMENT_LIST = {'id': int, 'title': str, 'status': str, 'created_at': str}

DOCUMENT_DETAIL = {
    'id': int,
    'title': str,
    'source_path': str,
    'status': str,
    'markdown': str,
    'error': str,
    'created_at': str,
    'updated_at': str,
}

DOCUMENT_CREATED = {'id': int, 'title': str, 'status': str, 'job_id': str}

DOCUMENT_DELETED = {'deleted': int}

SEARCH_STARTED = {'id': int, 'status': str, 'job_id': str}

SEARCH_LIST = {'id': int, 'query': str, 'status': str, 'created_at': str}

SEARCH_DETAIL = {
    'id': int,
    'query': str,
    'scope': str,
    'depth': str,
    'status': str,
    'answer': str,
    'sources': list,
    'error': str,
    'created_at': str,
}

JOB = {'job_id': str, 'status': str}

JOB_STATES = {
    'pending',
    'received',
    'started',
    'retry',
    'failure',
    'success',
    'revoked',
    'rejected',
    'ignored',
}

USER_ME = {'id': str, 'email': str, 'full_name': str, 'locale': str}

USER_EXPORT = {'user': dict}

NOT_FOUND = {'detail': str}
