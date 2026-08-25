export type DevState = 'success' | 'empty' | 'first-run' | 'loading' | 'error' | 'denied';

export const DEV_STATES: DevState[] = ['success', 'empty', 'first-run', 'loading', 'error', 'denied'];

/** The gateway address every sample below is written against. Sourced from the
 *  root .env so the curl/SDK snippets on this page are copy-pasteable as-is. */
const GATEWAY_ORIGIN = process.env.NEXT_PUBLIC_API_BASE_URL ?? '';
const gatewayUrl = (() => {
  try {
    return new URL(GATEWAY_ORIGIN);
  } catch {
    return null;
  }
})();

export const GATEWAY = {
  origin: GATEWAY_ORIGIN,
  bind: gatewayUrl?.hostname ?? '',
  port: gatewayUrl?.port ?? '',
};

export const SERVER = {
  bind: GATEWAY.bind,
  port: GATEWAY.port,
  baseUrl: `${GATEWAY.origin}/v1`,
  address: GATEWAY.origin,
  uptime: '2h 14m',
  since: '10:03 AM',
  requests: '312',
  requestsSub: '0 errors · 99.7% 2xx',
  throughput: '43',
  latency: '0.4 / 1.9',
  latencySub: '2 in flight',
  defaultModel: 'Llama-3.1-8B',
};

export type ApiTag = 'OpenAI' | 'Anthropic' | 'MCP';

export type Endpoint = { tag: ApiTag; url: string };

export const ENDPOINTS: Endpoint[] = [
  { tag: 'OpenAI', url: `${GATEWAY.origin}/v1/chat/completions` },
  { tag: 'OpenAI', url: `${GATEWAY.origin}/v1/models` },
  { tag: 'Anthropic', url: `${GATEWAY.origin}/v1/messages` },
];

export const MCP = {
  url: `${GATEWAY.origin}/mcp/sse`,
  transport: 'SSE + stdio',
  transportMeta: 'loopback only',
  tools: 'search_documents · get_document · list_models · chat',
  resources: 'converted documents (read-only)',
  resourcesMeta: '3 collections',
};

export type Route = {
  alias: string;
  target: string;
  meta: string;
  isDefault?: boolean;
};

export const ROUTES: Route[] = [
  { alias: 'gpt-4o-mini', target: 'Llama-3.1-8B-Instruct', meta: 'Q4_K_M · 4.1 GB · loaded', isDefault: true },
  { alias: 'claude-3-5-sonnet', target: 'Qwen2.5-14B-Instruct', meta: 'Q5_K_M · 9.8 GB · loaded' },
  { alias: '* (unmatched)', target: 'fall back to default model', meta: 'Llama-3.1-8B' },
];

export type LogStatus = 'ok' | 'warn' | 'err';

export type LogRow = {
  time: string;
  method: 'POST' | 'GET';
  path: string;
  model: string;
  code: string;
  status: LogStatus;
  latency: string;
};

export const LOG_ROWS: LogRow[] = [
  { time: '12:17:04', method: 'POST', path: '/v1/chat/completions', model: 'Llama-3.1-8B', code: '200', status: 'ok', latency: '0.38 s' },
  { time: '12:16:58', method: 'POST', path: '/v1/messages', model: 'Qwen2.5-14B', code: '200', status: 'ok', latency: '2.04 s' },
  { time: '12:16:40', method: 'GET', path: '/v1/models', model: '—', code: '200', status: 'ok', latency: '0.01 s' },
  { time: '12:16:33', method: 'POST', path: '/v1/chat/completions', model: 'Llama-3.1-8B', code: '429', status: 'warn', latency: '— queued' },
  { time: '12:16:09', method: 'POST', path: '/v1/chat/completions', model: 'Llama-3.1-8B', code: '200', status: 'ok', latency: '0.41 s' },
  { time: '12:15:52', method: 'POST', path: '/v1/messages', model: '—', code: '401', status: 'err', latency: '0.00 s' },
];

export type ApiKey = {
  masked: string;
  created: string;
  lastUsed: string;
  label: string;
};

export const API_KEYS: ApiKey[] = [
  { masked: 'phx_live_••••••••••7a2c', created: '2026-05-18', lastUsed: '2 min ago', label: 'Claude Code local' },
  { masked: 'phx_live_••••••••••b31f', created: '2026-04-02', lastUsed: '3 days ago', label: 'OpenAI SDK test' },
];

export const SNIPPET_TABS = ['curl', 'Python · OpenAI', 'Claude Code'] as const;
export type SnippetTab = (typeof SNIPPET_TABS)[number];

export const SNIPPETS: Record<SnippetTab, string> = {
  curl: `# OpenAI-compatible chat completion
curl ${GATEWAY.origin}/v1/chat/completions \\
  -H "Authorization: Bearer phx_live_••••••••••7a2c" \\
  -H "Content-Type: application/json" \\
  -d '{
    "model": "gpt-4o-mini",
    "messages": [{"role":"user","content":"Hello!"}],
    "stream": true
  }'`,
  'Python · OpenAI': `# Python — OpenAI SDK pointed at Phoenix
from openai import OpenAI
client = OpenAI(
    base_url="${GATEWAY.origin}/v1",
    api_key="phx_live_••••••••••7a2c",
)
resp = client.chat.completions.create(
    model="gpt-4o-mini",   # routed → Llama-3.1-8B
    messages=[{"role": "user", "content": "Hello!"}],
)`,
  'Claude Code': `# Claude Code — use Phoenix's local gateway
export ANTHROPIC_BASE_URL="${GATEWAY.origin}"
export ANTHROPIC_API_KEY="phx_live_••••••••••7a2c"
claude  # now answers from on-device models`,
};

export const LANGCHAIN_SNIPPET = `# LangChain — use Phoenix's on-device models, no cloud
from langchain_openai import ChatOpenAI
llm = ChatOpenAI(
    base_url="${GATEWAY.origin}/v1",
    api_key="phx_live_••••••••••7a2c",
    model="gpt-4o-mini",   # routed → Llama-3.1-8B
)
# For documents: convert in Phoenix, then load the exported
# Markdown/JSON with LangChain's DoclingLoader / JSONLoader.`;

export const BOOT_LOG = [
  `[10:03:01] binding socket ${GATEWAY.bind}:${GATEWAY.port} …`,
  '[10:03:01] initialising worker pool (4 threads) …',
  '[10:03:02] loading model Llama-3.1-8B (Q4_K_M) …',
];
