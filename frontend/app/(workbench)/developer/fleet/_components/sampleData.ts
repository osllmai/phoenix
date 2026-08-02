export type FleetState = 'success' | 'empty' | 'first-run' | 'loading' | 'error' | 'denied';

export type WorktreeStatus = 'run' | 'done' | 'wait' | 'block';

export type Worktree = {
  agent: string;
  path: string;
  status: WorktreeStatus;
  add?: number;
  del?: number;
  note?: string;
};

export type LaneStatus = 'run' | 'done' | 'queued' | 'failed';
export type LaneRoute = 'local' | 'cloud' | 'denied';

export type LaneLine = { text: string; tone?: 'pr' | 'ok' | 'er' | 'dim' | 'add'; caret?: boolean };

export type Lane = {
  name: string;
  role: string;
  status: LaneStatus;
  pillLabel: string;
  statusLabel: string;
  lines: LaneLine[];
  add?: number;
  del?: number;
  files?: number;
  elapsed: string;
  route: LaneRoute;
  routeLabel: string;
  cost?: string;
  footBtn: string;
};

export type DiffRow = {
  kind: 'hunk' | 'ctx' | 'add' | 'del' | 'annot';
  gut?: string;
  code: string;
  who?: string;
};

export type DiffFile = { key: string; name: string; stat: string; rows: DiffRow[] };

export type PickOption = { key: string; name: string; path: string; note?: string };

export type RosterAgent = { icon: string; name: string; tier: string; cloud?: boolean; on: boolean };

export const SAMPLE_PROMPT = 'add OAuth login + tests';

export const FANOUT_OPTIONS = [
  '4 agents · claude-code, codex, opencode, qwen',
  '3 agents · claude-code, codex, opencode',
  '2 agents · claude-code, codex',
  'Custom…',
];

export const BRANCH_OPTIONS = ['app/developer', 'production', '＋ new branch…'];

export const MERGE_STATUS = { clean: true, label: '✓ clean · no conflicts' };

export const PROMPT_PRESETS = ['add tests', 'fix failing build', 'refactor module', 'write docs'];

export const RECENT_PROMPTS = ['↺ add OAuth login + tests', '↺ speed up vector search'];

export const WORKTREES: Worktree[] = [
  { agent: 'claude-code', path: 'phoenix-cc-1', status: 'done', add: 128, del: 14 },
  { agent: 'codex', path: 'phoenix-cx-2', status: 'run', add: 96, del: 8 },
  { agent: 'opencode', path: 'phoenix-oc-3', status: 'done', add: 141, del: 22 },
  { agent: 'qwen-code', path: 'phoenix-qw-4', status: 'block', note: 'blocked' },
];

export const LANES: Lane[] = [
  {
    name: 'claude-code', role: '· opus', status: 'done', pillLabel: 'done ✓', statusLabel: 'done',
    add: 128, del: 14, files: 3, elapsed: '2m14s', route: 'local', routeLabel: 'local', cost: '~0¢', footBtn: 'open',
    lines: [
      { text: '> add provider, callback, session store', tone: 'pr' },
      { text: 'edit auth/oauth.py +82', tone: 'dim' },
      { text: 'edit tests/auth_test.py +46', tone: 'dim' },
      { text: '✓ 12 tests pass · ruff clean', tone: 'ok' },
    ],
  },
  {
    name: 'codex', role: '· gpt-5', status: 'run', pillLabel: 'running', statusLabel: 'running',
    add: 96, del: 8, files: 2, elapsed: '1m08s', route: 'local', routeLabel: 'local', cost: '~0¢', footBtn: 'open',
    lines: [
      { text: '$ codex exec "implement oauth + tests"', tone: 'pr' },
      { text: 'edit auth/oauth.py +71', tone: 'dim' },
      { text: 'writing tests/auth_test.py', caret: true },
    ],
  },
  {
    name: 'opencode', role: '· qwen-32b', status: 'done', pillLabel: 'done', statusLabel: 'done',
    add: 141, del: 22, files: 4, elapsed: '2m02s', route: 'local', routeLabel: 'local', cost: '~0¢', footBtn: 'open',
    lines: [
      { text: '> oauth via authlib + session middleware', tone: 'pr' },
      { text: 'edit auth/oauth.py +103', tone: 'dim' },
      { text: '✗ 2 tests fail · callback 500', tone: 'er' },
    ],
  },
  {
    name: 'qwen-code', role: '· local', status: 'failed', pillLabel: 'blocked', statusLabel: 'blocked',
    elapsed: '0m11s', route: 'denied', routeLabel: 'denied', footBtn: 'allow once',
    lines: [
      { text: 'needs network: pip install authlib', tone: 'dim' },
      { text: 'egress-locked · request denied', tone: 'dim' },
    ],
  },
];

export const PICK_OPTIONS: PickOption[] = [
  { key: 'cc', name: 'claude-code', path: 'phoenix-cc-1', note: '+128/−14 ✓' },
  { key: 'cx', name: 'codex', path: 'phoenix-cx-2', note: 'running…' },
  { key: 'oc', name: 'opencode', path: 'phoenix-oc-3', note: '✗ tests' },
];

export const ANNOTATION_COUNT = 1;

export const DIFF_FILES: DiffFile[] = [
  {
    key: 'oauth', name: 'auth/oauth.py', stat: '+82 −14',
    rows: [
      { kind: 'hunk', code: '@@ -1,4 +1,9 @@ OAuth provider + callback' },
      { kind: 'ctx', gut: '12', code: ' from config import settings' },
      { kind: 'add', gut: '13', code: '+from authlib.integrations.starlette_client import OAuth' },
      { kind: 'add', gut: '14', code: '+oauth = OAuth()' },
      { kind: 'add', gut: '15', code: '+oauth.register("github", client_id=settings.gh_id, ...)' },
      { kind: 'annot', who: 'you ·', code: 'gate the redirect on settings.allowed_hosts before merge — open-redirect risk.' },
      { kind: 'del', gut: '17', code: '-def login(): pass' },
      { kind: 'add', gut: '18', code: '+async def login(request): return await oauth.github.authorize_redirect(...)' },
    ],
  },
  {
    key: 'tests', name: 'tests/auth_test.py', stat: '+46',
    rows: [
      { kind: 'hunk', code: '@@ +0,46 @@ tests/auth_test.py (new)' },
      { kind: 'add', gut: '1', code: '+async def test_login_redirects_to_github(client):' },
      { kind: 'add', gut: '2', code: '+    r = await client.get("/auth/login")' },
      { kind: 'add', gut: '3', code: '+    assert r.status_code == 307' },
      { kind: 'add', gut: '4', code: '+    assert "github.com/login/oauth" in r.headers["location"]' },
    ],
  },
  {
    key: 'api', name: 'config/api.py', stat: '+9',
    rows: [
      { kind: 'hunk', code: '@@ -22,6 +22,9 @@ config/api.py' },
      { kind: 'ctx', gut: '22', code: ' api.add_router("/chat/", chat_router)' },
      { kind: 'add', gut: '23', code: '+api.add_router("/auth/", auth_router)' },
    ],
  },
];

export const FIRST_RUN_ROSTER: RosterAgent[] = [
  { icon: '🤖', name: 'claude-code', tier: 'A', on: true },
  { icon: '⌨', name: 'codex', tier: 'A', on: true },
  { icon: '🧩', name: 'opencode', tier: 'A', on: true },
  { icon: '🜂', name: 'qwen-code', tier: 'A', on: false },
  { icon: '☁', name: 'gemini-cli · cloud', tier: 'B', cloud: true, on: false },
];
