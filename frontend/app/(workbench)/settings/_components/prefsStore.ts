'use client';

import {
  ACCELERATORS,
  CHAT_MODELS,
  CONTEXT_LENGTHS,
  DATA_DIR,
  DEFAULT_MODELS,
  EMBED_MODELS,
  LANGUAGES,
  STARTUP_VIEWS,
} from '../sample';

export type Prefs = {
  language: string;
  startup: string;
  defaultModel: string;
  launchAtLogin: boolean;
  chatModel: string;
  embedModel: string;
  contextLength: string;
  accelerator: string;
  gpuLayers: number;
  cpuThreads: number;
  telemetry: boolean;
  analytics: boolean;
  dataLocation: string;
  database: string;
  databaseUrl: string;
  serverPort: string;
};

export const PREFS_KEY = 'phoenix.prefs';

export const DEFAULT_PREFS: Prefs = {
  language: LANGUAGES[0],
  startup: STARTUP_VIEWS[0],
  defaultModel: DEFAULT_MODELS[0],
  launchAtLogin: false,
  chatModel: CHAT_MODELS[0],
  embedModel: EMBED_MODELS[0],
  contextLength: CONTEXT_LENGTHS[2],
  accelerator: ACCELERATORS[0],
  gpuLayers: 32,
  cpuThreads: 8,
  telemetry: false,
  analytics: false,
  dataLocation: DATA_DIR,
  database: 'SQLite (on-device)',
  databaseUrl: '',
  serverPort: '16000',
};

export function readPrefs(): Prefs {
  if (typeof window === 'undefined') return DEFAULT_PREFS;
  try {
    const raw = window.localStorage.getItem(PREFS_KEY);
    if (!raw) return DEFAULT_PREFS;
    return { ...DEFAULT_PREFS, ...JSON.parse(raw) };
  } catch {
    return DEFAULT_PREFS;
  }
}

export function writePrefs(value: Prefs): void {
  if (typeof window === 'undefined') return;
  window.localStorage.setItem(PREFS_KEY, JSON.stringify(value));
}
