import 'fleet_models.dart';

export 'fleet_models.dart';

const fleetSample = FleetData(
  pair: MaestroPair(
    label: 'on desktop · paired',
    host: 'races on “studio-mbp”',
  ),
  promptDraft: 'add OAuth login + tests',
  presets: [
    MaestroPreset(label: 'add tests'),
    MaestroPreset(label: 'fix build'),
    MaestroPreset(label: 'refactor'),
    MaestroPreset(label: 'rerun last'),
  ],
  runTitle: 'add OAuth login + tests',
  runMeta: '4 agents · isolated worktrees · auto-stop on first green ✓',
  worktreesSummary: '3 done · 1 blocked',
  worktrees: [
    FleetWorktree(
      name: 'claude-code',
      path: 'phoenix-cc-1',
      statusLabel: '★ leads',
      state: FleetWorktreeState.done,
      summary: ['12 tests pass · ruff clean.'],
      diffstat: '+128 −14 · 3 files',
      meta: '2m14s · local · ~0¢',
      leads: true,
      canViewDiff: true,
    ),
    FleetWorktree(
      name: 'codex',
      path: 'phoenix-cx-2',
      statusLabel: 'running',
      state: FleetWorktreeState.running,
      summary: ['Writing tests/auth_test.py…'],
      diffstat: '+96 −8 · 2 files',
      meta: '1m08s · local · ~0¢',
    ),
    FleetWorktree(
      name: 'opencode',
      path: 'phoenix-oc-3',
      statusLabel: 'done',
      state: FleetWorktreeState.done,
      summary: ['2 tests fail · callback 500.'],
      diffstat: '+141 −22 · 4 files',
      meta: '2m02s · local · ~0¢',
      canViewDiff: true,
    ),
    FleetWorktree(
      name: 'qwen-code',
      path: 'phoenix-qw-4',
      statusLabel: 'blocked',
      state: FleetWorktreeState.blocked,
      summary: ['Needs network (authlib) · egress-locked, denied.'],
      meta: '0m11s · denied',
      routeDenied: true,
    ),
  ],
  merge: FleetMerge(
    winner: 'claude-code',
    summary: 'claude-code won the race — +128/−14, 12 tests pass.',
    badge: '✓ clean · no conflicts',
    branches: ['app/developer', 'production'],
  ),
  events: [
    MaestroEvent(
      time: '10:42',
      actor: 'maestro',
      text: '· 4 worktrees',
      outcome: 'fan out',
    ),
    MaestroEvent(
      time: '10:44',
      actor: 'claude',
      text: '→ done',
      outcome: '12 tests pass ✓',
    ),
    MaestroEvent(time: '10:44', actor: 'opencode', text: '→ 2 tests fail'),
    MaestroEvent(
      time: '10:45',
      actor: 'qwen',
      text: '· egress denied',
      outcome: 'blocked',
    ),
  ],
);
