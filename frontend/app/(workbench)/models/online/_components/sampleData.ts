export type OnlineModel = {
  id: string;
  name: string;
  provider: string;
  icon: string;
  iconBg: string;
  context: string;
  inputPrice: string;
  outputPrice: string;
  latency: string;
  throughput: string;
  comment: string;
  recommended?: string;
  vision?: boolean;
  tools?: boolean;
  isDefault?: boolean;
};

export type ProviderEntry = {
  id: string;
  name: string;
  dot: string;
  count: number | null;
};

export const PROVIDER_RAIL: ProviderEntry[] = [
  { id: 'all', name: 'All providers', dot: 'var(--success-base)', count: 9 },
  { id: 'openai', name: 'OpenAI', dot: 'var(--accent-primary)', count: 2 },
  { id: 'anthropic', name: 'Anthropic', dot: 'var(--warning-base)', count: 2 },
  { id: 'google', name: 'Google', dot: 'var(--info-base)', count: 1 },
  { id: 'mistral', name: 'Mistral AI', dot: 'var(--plum-base)', count: 1 },
  { id: 'groq', name: 'Groq', dot: 'var(--success-ink)', count: 1 },
  { id: 'deepseek', name: 'DeepSeek', dot: 'var(--error-base)', count: 1 },
  { id: 'cohere', name: 'Cohere', dot: 'var(--text-disabled)', count: null },
  { id: 'xai', name: 'xAI', dot: 'var(--text-disabled)', count: null },
];

export const SAMPLE_ONLINE_MODELS: OnlineModel[] = [
  {
    id: 'openai/gpt-4o',
    name: 'GPT-4o',
    provider: 'openai',
    icon: '⬡',
    iconBg: 'var(--accent-subtle)',
    context: '128k',
    inputPrice: '$2.50',
    outputPrice: '$10.00',
    latency: '~0.4s',
    throughput: '~90',
    comment:
      'Flagship multimodal — strong general reasoning, vision, and reliable tool calling for agents.',
    recommended: '★ Recommended',
    vision: true,
    tools: true,
    isDefault: true,
  },
  {
    id: 'openai/gpt-4o-mini',
    name: 'GPT-4o mini',
    provider: 'openai',
    icon: '⚡',
    iconBg: 'var(--accent-subtle)',
    context: '128k',
    inputPrice: '$0.15',
    outputPrice: '$0.60',
    latency: '~0.3s',
    throughput: '~140',
    comment:
      'Low-cost workhorse — great for high-volume classification, summarisation, and routing.',
    vision: true,
    tools: true,
  },
  {
    id: 'anthropic/claude-3-5-sonnet',
    name: 'Claude 3.5 Sonnet',
    provider: 'anthropic',
    icon: '✶',
    iconBg: 'var(--warning-bg)',
    context: '200k',
    inputPrice: '$3.00',
    outputPrice: '$15.00',
    latency: '~0.5s',
    throughput: '~75',
    comment:
      'Best-in-class coding and long-document reasoning — excellent agentic tool use over a 200k window.',
    recommended: '★ Recommended',
    vision: true,
    tools: true,
  },
  {
    id: 'anthropic/claude-3-5-haiku',
    name: 'Claude 3.5 Haiku',
    provider: 'anthropic',
    icon: '◆',
    iconBg: 'var(--warning-bg)',
    context: '200k',
    inputPrice: '$0.80',
    outputPrice: '$4.00',
    latency: '~0.3s',
    throughput: '~130',
    comment:
      'Fast and affordable — near-Sonnet quality for everyday tasks at a fraction of the cost.',
    tools: true,
  },
  {
    id: 'google/gemini-1.5-pro',
    name: 'Gemini 1.5 Pro',
    provider: 'google',
    icon: '✦',
    iconBg: 'var(--info-bg)',
    context: '2M',
    inputPrice: '$1.25',
    outputPrice: '$5.00',
    latency: '~0.6s',
    throughput: '~65',
    comment:
      'Enormous 2M-token context — ideal for whole-codebase or book-length document analysis.',
    recommended: '★ Long ctx',
    vision: true,
    tools: true,
  },
  {
    id: 'mistral/mistral-large-latest',
    name: 'Mistral Large',
    provider: 'mistral',
    icon: '🌀',
    iconBg: 'var(--plum-bg)',
    context: '128k',
    inputPrice: '$2.00',
    outputPrice: '$6.00',
    latency: '~0.5s',
    throughput: '~80',
    comment:
      'European flagship — strong reasoning and multilingual coverage with open-weights heritage.',
    tools: true,
  },
  {
    id: 'groq/llama-3.3-70b',
    name: 'Llama 3.3 70B',
    provider: 'groq',
    icon: '🦙',
    iconBg: 'var(--success-bg)',
    context: '128k',
    inputPrice: '$0.59',
    outputPrice: '$0.79',
    latency: '~0.1s',
    throughput: '~280',
    comment:
      "Open-weights Llama on Groq's LPU — one of the fastest hosted endpoints for low-latency chat.",
    recommended: '★ Very fast',
    tools: true,
  },
  {
    id: 'deepseek/deepseek-chat',
    name: 'DeepSeek V3',
    provider: 'deepseek',
    icon: '🐋',
    iconBg: 'var(--error-bg)',
    context: '64k',
    inputPrice: '$0.27',
    outputPrice: '$1.10',
    latency: '~0.7s',
    throughput: '~60',
    comment:
      'Exceptional price-to-performance — strong coding and math at the lowest cost on the catalog.',
    recommended: '★ Cheapest',
    tools: true,
  },
];

export const FILTER_PILLS = [
  'All',
  'Recommended',
  'Vision',
  'Tools',
  'Cheapest',
  'Long context',
];

export const SORT_OPTIONS = [
  'Sort: Recommended',
  'Price ↑',
  'Context ↓',
  'Latency ↑',
];

export const CREDITS = { balance: '$42.18', percent: 64 };
