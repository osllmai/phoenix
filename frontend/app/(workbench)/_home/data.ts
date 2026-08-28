export type HomeState = 'success' | 'empty' | 'first-run' | 'loading' | 'error' | 'denied';

export const HOME_STATES: HomeState[] = [
  'success',
  'empty',
  'first-run',
  'loading',
  'error',
  'denied',
];

export const sampleModel = {
  name: 'Llama-3.1-8B-Instruct',
  icon: '🧠',
  quant: 'Q4_K_M · GGUF',
  context: '8K context · GPU',
  status: 'Loaded · ready',
  stats: [
    { v: '43 tok/s', k: 'Throughput' },
    { v: '5.4 GB', k: 'VRAM in use' },
    { v: '128 ms', k: 'First token' },
  ],
  alternatives: [
    'Qwen2.5-7B-Instruct · Q5_K_M',
    'Mistral-7B-Instruct · Q4_K_M',
    'DeepSeek-Coder-6.7B · Q4_K_M',
    'Phi-3.5-mini · Q8_0',
  ],
};

export const quickActions = [
  { icon: '💬', title: 'New chat', sub: 'Start a conversation with the loaded model', href: '/chat' },
  { icon: '📄', title: 'Add document', sub: 'Convert & index a PDF or office file', href: '/documents' },
  { icon: '🔎', title: 'Search', sub: 'DeepSearch across your indexed docs', href: '/deepsearch' },
];

export const recentConversations = [
  { icon: '💬', title: 'Refactoring the inference port abstraction', meta: 'Llama-3.1-8B · 1,842 tokens', time: '14:01' },
  { icon: '🔎', title: 'What does the Q3 report say about churn?', meta: 'Qwen2.5-7B · DeepSearch · 4,310 tokens', time: '13:48' },
  { icon: '💬', title: 'Draft release notes for v0.4', meta: 'Mistral-7B · 2,217 tokens', time: '12:55' },
  { icon: '💬', title: 'Explain this stack trace', meta: 'DeepSeek-Coder · 3,091 tokens', time: '11:20' },
];

export const conversationTotal = 37;

export const docLibrary = {
  counts: [
    { n: '18', l: 'total documents' },
    { n: '312', l: 'MB indexed' },
  ],
  pills: [
    { kind: 'embedded' as const, label: '✓ 14 embedded' },
    { kind: 'converting' as const, label: '⟳ 2 converting' },
    { kind: 'queued' as const, label: '• 2 queued' },
  ],
};

export const serverStatus = {
  state: 'Running',
  host: 'localhost',
  uptime: 'uptime 4h 12m',
  endpoints: [
    { method: 'POST', path: '/v1/chat/completions', label: 'OpenAI' },
    { method: 'POST', path: '/v1/messages', label: 'Anthropic' },
  ],
};

export const resourceMeters = [
  { label: 'VRAM', pct: 68, level: 'warn' as const, value: '5.4 / 8.0 GB' },
  { label: 'RAM', pct: 41, level: 'ok' as const, value: '13.1 / 32 GB' },
  { label: 'Disk', pct: 84, level: 'hot' as const, value: '421 / 500 GB' },
];

export const tips = [
  { icon: '⌘', title: 'Quick switch', sub: 'Press ⌘K to jump to any model, chat, or document.' },
  { icon: '🔌', title: 'Use the API', sub: 'Point any OpenAI/Anthropic client at your local server.' },
  { icon: '📄', title: 'Chat with docs', sub: 'Add a PDF, then ask questions grounded in its content.' },
];

export const firstRunFeatures = [
  { icon: '💬', title: 'Chat', sub: 'Fully local inference via llama.cpp' },
  { icon: '🔎', title: 'DeepSearch', sub: 'RAG over your indexed documents' },
  { icon: '📄', title: 'Docs', sub: 'PDF & office conversion via Docling' },
];
