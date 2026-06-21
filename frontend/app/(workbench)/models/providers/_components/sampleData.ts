export type ProvidersState =
  | 'success'
  | 'add'
  | 'empty'
  | 'first-run'
  | 'loading'
  | 'error'
  | 'denied';

export const PROVIDERS_STATES: ProvidersState[] = [
  'success',
  'add',
  'empty',
  'first-run',
  'loading',
  'error',
  'denied',
];

export type KeyBadge = 'byok' | 'via' | 'local';
export type RowStatus = 'connected' | 'disabled' | 'unconnected' | 'denied' | 'failed';
export type DotColor = 'success' | 'plum' | 'info' | 'warning' | 'accent' | 'disabled' | 'error';

export type Provider = {
  id: string;
  label: string;
  endpoint: string;
  dot: DotColor;
  status: RowStatus;
  badge?: KeyBadge;
  maskedKey?: string;
  noKeyNote?: string;
  errorChip?: string;
  retryLabel?: string;
  models?: number;
  enabled: boolean;
  toggleDisabled?: boolean;
  isDefault?: boolean;
};

export const GATEWAY = {
  name: 'IndoxHub gateway',
  tagline:
    'Connect once — reach every provider through IndoxHub. One key, all providers, pay with credits.',
  sampleKey: 'idx-prod-9c1d4b2a6f8e2f7a',
  creditsRemaining: '$12.40',
  usedThisMonth: '$6.22',
  usedPercent: 34,
};

export const SAMPLE_PROVIDERS: Provider[] = [
  {
    id: 'openai',
    label: 'OpenAI',
    endpoint: 'api.openai.com/v1',
    dot: 'success',
    status: 'connected',
    badge: 'byok',
    maskedKey: 'sk-proj-••••••••3a9f',
    models: 12,
    enabled: true,
  },
  {
    id: 'anthropic',
    label: 'Anthropic',
    endpoint: 'api.anthropic.com/v1',
    dot: 'plum',
    status: 'connected',
    badge: 'byok',
    maskedKey: 'sk-ant-••••7fA',
    models: 8,
    enabled: true,
  },
  {
    id: 'google',
    label: 'Google · Gemini',
    endpoint: 'routed via IndoxHub',
    dot: 'info',
    status: 'connected',
    badge: 'via',
    noKeyNote: 'via gateway — no key needed',
    models: 5,
    enabled: true,
  },
  {
    id: 'ollama',
    label: 'Ollama',
    endpoint: 'http://localhost/v1',
    dot: 'success',
    status: 'connected',
    badge: 'local',
    noKeyNote: 'no key — local endpoint',
    models: 7,
    enabled: true,
  },
  {
    id: 'custom',
    label: 'Custom · OpenAI-compatible',
    endpoint: 'https://llm.internal.example/v1',
    dot: 'warning',
    status: 'connected',
    badge: 'byok',
    maskedKey: 'cust-••••••••b72c',
    models: 3,
    enabled: true,
  },
  {
    id: 'mistral',
    label: 'Mistral AI',
    endpoint: 'routed via IndoxHub',
    dot: 'accent',
    status: 'disabled',
    badge: 'via',
    noKeyNote: 'via gateway — no key needed',
    models: 6,
    enabled: false,
  },
  {
    id: 'together',
    label: 'Together AI',
    endpoint: 'api.together.xyz/v1',
    dot: 'disabled',
    status: 'unconnected',
    enabled: false,
    toggleDisabled: true,
  },
  {
    id: 'groq',
    label: 'Groq',
    endpoint: 'api.groq.com/openai/v1',
    dot: 'disabled',
    status: 'unconnected',
    enabled: false,
    toggleDisabled: true,
  },
];

export const ADD_PROVIDER_OPTIONS = [
  'OpenAI',
  'Anthropic',
  'Google · Gemini',
  'Ollama (local network)',
  'Custom · OpenAI-compatible',
  'Mistral AI',
  'Groq',
  'Together AI',
];

export const DOT_VAR: Record<DotColor, string> = {
  success: 'var(--success-base)',
  plum: 'var(--plum-base)',
  info: 'var(--info-base)',
  warning: 'var(--warning-base)',
  accent: 'var(--accent-primary)',
  disabled: 'var(--text-disabled)',
  error: 'var(--error-base)',
};
