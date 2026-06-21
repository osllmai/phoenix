export type ModelOption = {
  id: string;
  ico: string;
  label: string;
  sub: string;
  size: string;
  quant: string;
};

export const MODELS: ModelOption[] = [
  {
    id: 'llama-3.2-3b',
    ico: '🦙',
    label: 'Llama 3.2 3B Instruct',
    sub: 'Great all-rounder · fast on most laptops',
    size: '2.0 GB',
    quant: 'Q4_K_M',
  },
  {
    id: 'qwen-2.5-7b',
    ico: '🌐',
    label: 'Qwen 2.5 7B Instruct',
    sub: 'Strong reasoning & multilingual',
    size: '4.7 GB',
    quant: 'Q4_K_M',
  },
  {
    id: 'granite-3.1-2b',
    ico: '🪨',
    label: 'Granite 3.1 2B Instruct',
    sub: 'Compact · low memory · tool-use ready',
    size: '1.5 GB',
    quant: 'Q4_K_M',
  },
];

export const WELCOME_FEATURES = [
  {
    ico: '🧠',
    title: 'On-device inference',
    desc: 'Local models via llama.cpp — no cloud, no API keys.',
  },
  {
    ico: '📄',
    title: 'Multi-format documents',
    desc: 'PDF, Office, images & audio → clean markdown via Docling.',
  },
  {
    ico: '🖥️',
    title: 'Local API server',
    desc: 'OpenAI- & Anthropic-compatible endpoints on localhost.',
  },
  {
    ico: '🔒',
    title: 'Full privacy',
    desc: 'Chats stored locally in SQLite. Offline-first.',
  },
];

export const PRIVACY_POINTS = [
  {
    icon: '🔒',
    title: 'Inference runs entirely on-device',
    desc: 'Your prompts and files never leave your computer.',
  },
  {
    icon: '📡',
    title: 'No network required',
    desc: 'Chat, search, and generate without an internet connection.',
  },
  {
    icon: '🗂',
    title: 'Conversations stored locally',
    desc: 'Everything is kept in an on-device SQLite database — no cloud sync.',
  },
];

export const TELEMETRY_LABEL = 'Anonymous usage telemetry';
export const TELEMETRY_HELP = 'Off by default. No prompts or content is ever collected.';
