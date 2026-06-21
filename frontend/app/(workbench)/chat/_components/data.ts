export type ChatState = 'success' | 'empty' | 'first-run' | 'loading' | 'error' | 'denied';

export const CHAT_STATES: ChatState[] = [
  'success',
  'empty',
  'first-run',
  'loading',
  'error',
  'denied',
];

export type Convo = {
  id: string;
  title: string;
  snippet: string;
  time?: string;
  pinned?: boolean;
  selected?: boolean;
  group: string;
};

export const SAMPLE_CONVOS: Convo[] = [
  {
    id: 'c1',
    title: 'Quantization trade-offs',
    snippet: 'Q4_K_M keeps most quality at ~half VRAM…',
    pinned: true,
    selected: true,
    group: 'Pinned',
  },
  {
    id: 'c2',
    title: 'Streaming tokens in Dart',
    snippet: 'Read stdout line-by-line and map __DONE__…',
    time: '2m',
    group: 'Today',
  },
  {
    id: 'c3',
    title: 'Summarize the roadmap doc',
    snippet: 'Three milestones stand out for Q3…',
    time: '1h',
    group: 'Today',
  },
  {
    id: 'c4',
    title: 'Rust borrow checker help',
    snippet: "The lifetime 'a must outlive…",
    time: '1d',
    group: 'Yesterday',
  },
  {
    id: 'c5',
    title: 'Dinner ideas, pantry only',
    snippet: 'With chickpeas and spinach you could…',
    time: '1d',
    group: 'Yesterday',
  },
];

export type Cite = { src: string; meta: string; text: string };

export const SAMPLE_CITES: Cite[] = [
  {
    src: 'product-roadmap-2026.docx · p.4',
    meta: 'chunk 22 · 0.89',
    text: 'P11 — HTTP gateway exposes OpenAI /v1/chat/completions with SSE token streaming…',
  },
  {
    src: 'product-roadmap-2026.docx · p.5',
    meta: 'chunk 25 · 0.81',
    text: 'On-device inference (P9) must ship before the gateway; streaming reuses the same Stream API…',
  },
];

export const SAMPLE_CODE = `final proc = await Process.start(exe, ['--model', path]);
proc.stdout
  .transform(utf8.decoder)
  .transform(const LineSplitter())
  .takeWhile((l) => l != '__DONE__')
  .listen(controller.add);`;

export type LocalModel = { name: string; size: string; active?: boolean; dim?: boolean };
export type CloudModel = { name: string; dotColor: string };

export const LOCAL_MODELS: LocalModel[] = [
  { name: 'Llama-3.1-8B-Instruct · Q4_K_M', size: '4.1 GB', active: true },
  { name: 'Qwen2.5-7B-Instruct · Q5_K_M', size: '5.3 GB', dim: true },
];

export const CLOUD_MODELS: CloudModel[] = [
  { name: 'openai/gpt-4o', dotColor: 'var(--info-base)' },
  { name: 'mistral/mistral-large', dotColor: 'var(--plum-base)' },
];

export const RAG_SOURCES = [
  { name: 'product-roadmap-2026.docx', on: true },
  { name: 'llama-3-technical-report.pdf', on: true },
  { name: 'q3-financials.xlsx', on: false },
  { name: 'onboarding-guide.md', on: false },
];

export const SUGGESTIONS = [
  { title: 'Explain code', body: 'Walk through a tricky Rust borrow-checker error.' },
  { title: 'Summarize a doc', body: 'Pull the key milestones from my roadmap file.' },
  { title: 'Draft', body: 'Write a concise commit message from a diff.' },
  { title: 'Brainstorm', body: "Dinner ideas from what's in the pantry." },
];
