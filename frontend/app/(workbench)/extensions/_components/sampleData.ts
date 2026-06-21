export type ExtensionCategory =
  | 'doc'
  | 'speech'
  | 'search'
  | 'forecasting'
  | 'developer'
  | 'evaluator'
  | 'flows';

export type ExtensionTag = { label: string; category?: ExtensionCategory; size?: boolean };

export type Extension = {
  id: string;
  icon: string;
  name: string;
  verified?: boolean;
  publisher: string;
  rating?: number;
  installs?: string;
  description: string;
  tags: ExtensionTag[];
  installed?: boolean;
  installLabel?: string;
  group: string;
};

export const SAMPLE_EXTENSIONS: Extension[] = [
  {
    id: 'documents-docling',
    icon: '📄',
    name: 'Documents · Docling',
    verified: true,
    publisher: 'Phoenix',
    rating: 4.9,
    installs: '18k installs',
    description: 'Convert PDF / Office / images → clean markdown, with OCR, tables, chunking & RAG.',
    tags: [{ label: 'Document processing', category: 'doc' }, { label: 'backend +420 MB', size: true }],
    installed: true,
    group: 'Featured · First-party',
  },
  {
    id: 'speech-whisper',
    icon: '🎙️',
    name: 'Speech · Whisper',
    verified: true,
    publisher: 'Phoenix',
    rating: 4.7,
    installs: '11k installs',
    description: 'Transcribe audio & video on-device with Whisper (tiny → large-v3).',
    tags: [{ label: 'Speech', category: 'speech' }, { label: 'weights +75 MB+', size: true }],
    group: 'Featured · First-party',
  },
  {
    id: 'deepsearch',
    icon: '🔎',
    name: 'DeepSearch',
    verified: true,
    publisher: 'Phoenix',
    rating: 4.6,
    installs: '9k installs',
    description: 'Agentic web + local-document research with cited synthesis.',
    tags: [{ label: 'Search & research', category: 'search' }, { label: '+12 MB', size: true }],
    installed: true,
    group: 'Featured · First-party',
  },
  {
    id: 'server-gateway',
    icon: '🖥️',
    name: 'Server · API Gateway',
    verified: true,
    publisher: 'Phoenix',
    rating: 4.5,
    installs: '6k installs',
    description: 'Expose OpenAI /v1/chat/completions + Anthropic /v1/messages locally.',
    tags: [{ label: 'Developer' }, { label: '+8 MB', size: true }],
    group: 'Featured · First-party',
  },
  {
    id: 'forecasting-timesfm',
    icon: '📈',
    name: 'Forecasting · TimesFM',
    verified: true,
    publisher: 'Phoenix',
    rating: 4.6,
    installs: '3k installs',
    description:
      'Zero-shot time-series forecasting (point + P10–P90 quantiles) on local data. Backend job — not the chat engine.',
    tags: [{ label: 'Forecasting', category: 'forecasting' }, { label: 'backend +0.9 GB · torch', size: true }],
    group: 'Featured · First-party',
  },
  {
    id: 'market-ibkr',
    icon: '🟢',
    name: 'Market data · Interactive Brokers',
    verified: true,
    publisher: 'Phoenix · ★ 4.4 · 2k installs',
    description:
      'Pull OHLCV & portfolio series from IBKR (Client Portal API) into the Forecasting source picker. Account-gated, online.',
    tags: [
      { label: 'Forecasting', category: 'forecasting' },
      { label: 'Connector' },
      { label: 'account · online', size: true },
    ],
    installLabel: 'Connect',
    group: 'Data & connectors',
  },
  {
    id: 'market-yahoo',
    icon: '📉',
    name: 'Market data · Yahoo Finance',
    publisher: 'community · Apache-2.0 · no account',
    description: 'Free delayed OHLCV by ticker — quickest way to try Forecasting without a broker login.',
    tags: [
      { label: 'Forecasting', category: 'forecasting' },
      { label: 'Connector' },
      { label: 'online', size: true },
    ],
    group: 'Data & connectors',
  },
  {
    id: 'maestro',
    icon: '🎼',
    name: 'Maestro · agent orchestra',
    verified: true,
    publisher: 'Phoenix · first-party · desktop only',
    description: 'Run an agent-of-agents: a Conductor delegates to coding agents in sandboxed terminals.',
    tags: [{ label: 'Developer', category: 'developer' }, { label: 'desktop · Docker', size: true }],
    group: 'Developer agents · evaluators · flows',
  },
  {
    id: 'indoxjudge',
    icon: '⚖️',
    name: 'indoxJudge · evaluator',
    verified: true,
    publisher: 'Phoenix (osllmai) · first-party',
    description: 'Score outputs: faithfulness, hallucination, toxicity, bias, RAG — as quality gates.',
    tags: [{ label: 'Evaluator', category: 'evaluator' }, { label: 'local', size: true }],
    group: 'Developer agents · evaluators · flows',
  },
  {
    id: 'flows',
    icon: '🔀',
    name: 'Flows · workflow builder',
    verified: true,
    publisher: 'Phoenix · first-party · desktop only',
    description: 'Compose agents, tools & evaluators into reusable scenarios (n8n-style).',
    tags: [{ label: 'Flows', category: 'flows' }, { label: 'desktop', size: true }],
    group: 'Developer agents · evaluators · flows',
  },
];

export const RECOMMENDED_EXTENSIONS: Extension[] = SAMPLE_EXTENSIONS.slice(0, 3);

export const SHELL_STATS = {
  core: 'Core shell · 48 MB',
  installed: '3 installed',
  updates: '2 updates',
  note: 'Phoenix ships light — install only the features you need; each pulls its backend on demand.',
};

export const CATEGORY_CHIPS = [
  'All',
  'Featured',
  'Document processing',
  'Speech',
  'Search & research',
  'Forecasting',
  'Data & connectors',
  'Developer agents',
  'Evaluators',
  'Flows',
  'Installed',
  'Updates',
];
