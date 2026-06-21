'use client';

import { useState } from 'react';

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

export function useSettingsForm() {
  const [theme, setTheme] = useState('Dark');
  const [fontSize, setFontSize] = useState(15);
  const [accent, setAccent] = useState('ember');
  const [language, setLanguage] = useState(LANGUAGES[0]);
  const [startup, setStartup] = useState(STARTUP_VIEWS[0]);
  const [defaultModel, setDefaultModel] = useState(DEFAULT_MODELS[0]);
  const [launchAtLogin, setLaunchAtLogin] = useState(false);
  const [chatModel, setChatModel] = useState(CHAT_MODELS[0]);
  const [embedModel, setEmbedModel] = useState(EMBED_MODELS[0]);
  const [contextLength, setContextLength] = useState(CONTEXT_LENGTHS[2]);
  const [accelerator, setAccelerator] = useState(ACCELERATORS[0]);
  const [gpuLayers, setGpuLayers] = useState(32);
  const [cpuThreads, setCpuThreads] = useState(8);
  const [telemetry, setTelemetry] = useState(false);
  const [analytics, setAnalytics] = useState(false);
  const [dataLocation, setDataLocation] = useState(DATA_DIR);
  const [database, setDatabase] = useState('SQLite (on-device)');
  const [databaseUrl, setDatabaseUrl] = useState('');
  const [serverPort, setServerPort] = useState('16000');

  return {
    theme, setTheme,
    fontSize, setFontSize,
    accent, setAccent,
    language, setLanguage,
    startup, setStartup,
    defaultModel, setDefaultModel,
    launchAtLogin, setLaunchAtLogin,
    chatModel, setChatModel,
    embedModel, setEmbedModel,
    contextLength, setContextLength,
    accelerator, setAccelerator,
    gpuLayers, setGpuLayers,
    cpuThreads, setCpuThreads,
    telemetry, setTelemetry,
    analytics, setAnalytics,
    dataLocation, setDataLocation,
    database, setDatabase,
    databaseUrl, setDatabaseUrl,
    serverPort, setServerPort,
  };
}

export type SettingsForm = ReturnType<typeof useSettingsForm>;
