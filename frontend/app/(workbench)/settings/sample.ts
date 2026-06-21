export type SettingsState = 'success' | 'empty' | 'first-run' | 'loading' | 'error' | 'denied';

export const SECTIONS = [
  { id: 'appearance', icon: '🎨', label: 'Appearance' },
  { id: 'general', icon: '⚙️', label: 'General' },
  { id: 'models', icon: '🧠', label: 'Models & Inference' },
  { id: 'privacy', icon: '🔒', label: 'Privacy & Data' },
  { id: 'storage', icon: '💾', label: 'Storage' },
  { id: 'backend', icon: '🗄️', label: 'Backend' },
  { id: 'about', icon: 'ℹ️', label: 'About' },
] as const;

export const ACCENTS = [
  { id: 'ember', label: 'Ember (default)', varName: '--accent-primary' },
  { id: 'sage', label: 'Sage', varName: '--success-base' },
  { id: 'sky', label: 'Sky', varName: '--info-base' },
  { id: 'plum', label: 'Plum', varName: '--plum-base' },
  { id: 'gold', label: 'Gold', varName: '--warning-base' },
] as const;

export const CHAT_MODELS = [
  'Llama-3.1-8B-Instruct · Q4_K_M',
  'Mistral-7B-Instruct · Q5_K_M',
  'Phi-3-mini-4k · Q8_0',
];

export const EMBED_MODELS = ['nomic-embed-text-v1.5', 'BAAI/bge-small-en', 'all-MiniLM-L6-v2'];

export const CONTEXT_LENGTHS = ['2048', '4096', '8192', '16384', '32768'];

export const ACCELERATORS = ['Metal · Apple M3 (GPU)', 'CUDA · device 0', 'CPU only'];

export const LANGUAGES = ['English (US)', 'Français', 'Deutsch', '日本語'];

export const STARTUP_VIEWS = ['Home dashboard', 'Last conversation', 'New chat'];

export const DEFAULT_MODELS = [...CHAT_MODELS, '— None (choose each time) —'];

export const FIRST_RUN_MODELS = [
  'Llama-3.1-8B-Instruct · Q4_K_M (4.7 GB)',
  'Mistral-7B-Instruct · Q5_K_M (5.1 GB)',
  'Phi-3-mini-4k · Q8_0 (2.3 GB)',
];

export const DISK_USAGE = [
  { label: 'Model cache', pct: 74, value: '12.1 GB' },
  { label: 'Document store', pct: 28, value: '3.4 GB' },
  { label: 'Prompt KV-cache', pct: 9, value: '1.2 GB' },
];

export const VERSIONS = [
  { key: 'Phoenix', value: '0.9.1 (build 412)' },
  { key: 'llama.cpp engine', value: 'b3456 · GGUF 3' },
  { key: 'Flutter runtime', value: '3.22.1 · Dart 3.4.1' },
  { key: 'Platform', value: 'macOS 15.2 · Apple M3' },
];

export const SETTINGS_PATH = '~/Library/Application Support/Phoenix/settings.json';
export const DATA_DIR = '~/Library/Application Support/Phoenix';
export const DOCUMENT_STORE_SUMMARY = '42 documents · 3.4 GB';

export const LOCKED_FIELDS = [
  { name: 'Database', desc: 'Managed — cannot be changed here', value: 'Postgres (managed)', badge: 'Locked by admin' },
  {
    name: 'DATABASE_URL',
    desc: 'Set by administrator via environment',
    value: 'postgresql://phoenix:••••••@db.corp.example.com:5432/phoenix_prod',
    badge: 'Env var',
  },
  { name: 'Server port', desc: 'Managed — read-only', value: '16000', badge: 'Locked by admin' },
];
