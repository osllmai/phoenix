"""Seed one sample fan-out run so the Fleet screens render real data."""
from django.db import migrations

_PROMPT = 'add OAuth login + tests'

_LANES = [
    ('claude-code', 'opus', 'phoenix-cc-1', 'done', 'done',
     '12 tests pass · ruff clean.', 128, 14, 3, '2m14s', 'local', '~0¢', True),
    ('codex', 'gpt-5', 'phoenix-cx-2', 'running', 'running',
     'Writing tests/auth_test.py…', 96, 8, 2, '1m08s', 'local', '~0¢', False),
    ('opencode', 'qwen-32b', 'phoenix-oc-3', 'done', 'done',
     '2 tests fail · callback 500.', 141, 22, 4, '2m02s', 'local', '~0¢', False),
    ('qwen-code', 'local', 'phoenix-qw-4', 'blocked', 'blocked',
     'Needs network (authlib) · egress-locked, denied.', 0, 0, 0, '0m11s', 'denied', '', False),
]

_EVENTS = [
    ('10:42', 'maestro', '· 4 worktrees', 'fan out'),
    ('10:44', 'claude', '→ done', '12 tests pass ✓'),
    ('10:44', 'opencode', '→ 2 tests fail', ''),
    ('10:45', 'qwen', '· egress denied', 'blocked'),
]


def seed(apps, schema_editor):
    Run = apps.get_model('fleet', 'FleetRun')
    Lane = apps.get_model('fleet', 'FleetLane')
    Event = apps.get_model('fleet', 'FleetEvent')
    run = Run.objects.create(prompt=_PROMPT, base_branch='app/developer', race_mode=True)
    for (agent, role, path, state, label, summary, adds, dels, files,
         elapsed, route, cost, winner) in _LANES:
        Lane.objects.create(
            run=run, agent=agent, role=role, worktree_path=path, state=state,
            status_label=label, summary=summary, additions=adds, deletions=dels,
            files_changed=files, elapsed=elapsed, route=route, cost=cost, is_winner=winner,
        )
    for at, actor, text, outcome in _EVENTS:
        Event.objects.create(run=run, at=at, actor=actor, text=text, outcome=outcome)


def unseed(apps, schema_editor):
    apps.get_model('fleet', 'FleetRun').objects.filter(prompt=_PROMPT).delete()


class Migration(migrations.Migration):
    dependencies = [('fleet', '0001_initial')]
    operations = [migrations.RunPython(seed, unseed)]
