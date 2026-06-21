import 'maestro_models.dart';

export 'maestro_models.dart';

const maestroSample = MaestroData(
  pair: MaestroPair(label: 'on desktop · paired', host: 'runs on “studio-mbp”'),
  goalDraft: 'add OAuth login + tests',
  presets: [
    MaestroPreset(label: 'add tests'),
    MaestroPreset(label: 'review PR'),
    MaestroPreset(label: 'refactor module'),
    MaestroPreset(label: '↺ add OAuth login + tests'),
  ],
  goal: MaestroGoal(
    text: 'add OAuth login + tests',
    pattern: 'PIPELINE',
    flow: 'plan→impl→test→review',
    conductor: 'Conductor delegating',
  ),
  plan: [
    MaestroStep(
      marker: '✓',
      title: '1 · plan',
      meta: 'claude-code · 4 steps',
      statusLabel: 'done',
      state: MaestroStepState.done,
    ),
    MaestroStep(
      marker: '⠿',
      title: '2 · impl',
      meta: 'codex · 3 files changed…',
      statusLabel: 'running',
      state: MaestroStepState.running,
    ),
    MaestroStep(
      marker: '✋',
      title: '3 · tests',
      meta: 'needs your approval to run',
      statusLabel: 'gated',
      state: MaestroStepState.gated,
    ),
    MaestroStep(
      marker: '•',
      title: '4 · review',
      meta: 'droid · queued',
      statusLabel: 'queued',
      state: MaestroStepState.pending,
    ),
  ],
  approval: MaestroApproval(
    title: 'Approval needed',
    detail: 'Step 3 (tests) wants to run pytest and write '
        'tests/auth_test.py on the desktop worktree. '
        'Approve to let codex continue.',
  ),
  agents: [
    MaestroAgent(
      name: 'claude-code',
      role: '· plan',
      statusLabel: 'done',
      state: MaestroAgentState.done,
      lines: [
        'Drafted OAuth plan: provider, callback, session.',
        '4 steps · handoff → codex',
      ],
    ),
    MaestroAgent(
      name: 'codex',
      role: '· impl',
      statusLabel: 'running',
      state: MaestroAgentState.running,
      lines: [
        'Editing auth/oauth.py, config/api.py.',
        '+91 lines · 3 files · ~2 min in',
      ],
    ),
    MaestroAgent(
      name: 'droid',
      role: '· review',
      statusLabel: 'queued',
      state: MaestroAgentState.queued,
      lines: [
        'Waiting on impl handoff.',
        'worktree phoenix-droid-3 · read-only',
      ],
    ),
    MaestroAgent(
      name: 'phoenix-code',
      role: '· native',
      statusLabel: 'idle',
      state: MaestroAgentState.idle,
      lines: [
        'Fully-private path · local engine only.',
        'Ready · standing by',
      ],
    ),
  ],
  events: [
    MaestroEvent(
      time: '10:42',
      actor: 'claude',
      text: '· handoff codex',
      outcome: 'plan ready',
    ),
    MaestroEvent(time: '10:43', actor: 'codex', text: '→ start impl'),
    MaestroEvent(time: '10:44', actor: 'codex', text: '→ edit 3 files (+91)'),
    MaestroEvent(
      time: '10:45',
      actor: 'maestro',
      text: '· step 3',
      outcome: 'awaiting approval',
    ),
  ],
);
