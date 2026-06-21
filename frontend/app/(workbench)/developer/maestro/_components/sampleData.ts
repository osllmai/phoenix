export type MaestroState =
  | 'success'
  | 'empty'
  | 'first-run'
  | 'loading'
  | 'error'
  | 'denied';

export type StepStatus = 'done' | 'run' | 'pending';

export type PlanStep = {
  marker: string;
  title: string;
  meta: string;
  status: StepStatus;
};

export type TermStatus = 'run' | 'queued' | 'done' | 'idle' | 'failed';

export type TermLine = {
  text: string;
  tone?: 'pr' | 'ok' | 'wn' | 'er' | 'dim';
  caret?: boolean;
};

export type AgentTerminal = {
  name: string;
  role: string;
  status: TermStatus;
  pillLabel: string;
  lines: TermLine[];
};

export type RosterAgent = {
  icon: string;
  name: string;
  tier: string;
  on: boolean;
};

export const SAMPLE_GOAL = 'add OAuth login + tests';

export const PLAN_PATTERNS = [
  'PIPELINE · plan→impl→test→review',
  'PANEL · pick-best of N',
  'MAP-REDUCE · split→merge',
  'SOLO · one agent',
];

export const GOAL_PRESETS = ['add tests', 'review PR', 'refactor module', 'write docs'];

export const RECENT_GOALS = ['↺ add OAuth login + tests', '↺ migrate to django-ninja'];

export const PLAN_STEPS: PlanStep[] = [
  { marker: '✓', title: '1 · plan', meta: 'claude-code · decomposed 4 steps', status: 'done' },
  { marker: '⠿', title: '2 · impl', meta: 'codex · 3 files changed…', status: 'run' },
  { marker: '⠿', title: '3 · tests', meta: 'codex · writing auth_test.py', status: 'run' },
  { marker: '•', title: '4 · review', meta: 'droid · queued (waiting on impl)', status: 'pending' },
];

export const SAMPLE_TERMINALS: AgentTerminal[] = [
  {
    name: 'claude-code',
    role: '· plan',
    status: 'done',
    pillLabel: 'done',
    lines: [
      { text: '> reading auth/__init__.py, routes.py', tone: 'pr' },
      { text: '> drafting OAuth plan: provider, callback, session', tone: 'pr' },
      { text: '✓ plan ready · 4 steps · handoff → codex', tone: 'ok' },
    ],
  },
  {
    name: 'codex',
    role: '· impl',
    status: 'run',
    pillLabel: 'running',
    lines: [
      { text: '$ codex exec "implement oauth + tests"', tone: 'pr' },
      { text: 'edit auth/oauth.py  (+82)', tone: 'dim' },
      { text: 'edit config/api.py  (+9)', tone: 'dim' },
      { text: 'writing tests/auth_test.py', caret: true },
    ],
  },
  {
    name: 'droid',
    role: '· review',
    status: 'queued',
    pillLabel: 'queued',
    lines: [
      { text: '(waiting on impl handoff)', tone: 'dim' },
      { text: 'worktree: phoenix-droid-3 · read-only', tone: 'dim' },
    ],
  },
  {
    name: 'phoenix-code',
    role: '· native',
    status: 'idle',
    pillLabel: 'idle',
    lines: [
      { text: 'fully-private path · local engine only', tone: 'dim' },
      { text: 'ready · click to attach & type', tone: 'dim' },
    ],
  },
];

export const EVENT_LOG = [
  { agent: 'claude', rest: '→done' },
  { agent: 'claude', rest: '→handoff:codex' },
  { agent: 'codex', rest: '→start' },
  { agent: 'codex', rest: '→edit:3 files' },
  { agent: 'droid', rest: '→queued' },
];

export const ROSTER: RosterAgent[] = [
  { icon: '🤖', name: 'claude-code', tier: 'Tier A', on: true },
  { icon: '⌨', name: 'codex', tier: 'Tier A', on: true },
  { icon: '🜂', name: 'phoenix-code', tier: 'native', on: false },
  { icon: '📚', name: 'phoenix-doc', tier: 'native', on: false },
  { icon: '🔧', name: 'droid', tier: 'Tier C', on: false },
  { icon: '🧩', name: 'opencode', tier: 'Tier A', on: false },
];
