'use client';

import { useEffect, useState } from 'react';

import { DEFAULT_APPEARANCE, readAppearance, writeAppearance } from './appearanceStore';
import type { Appearance } from './appearanceStore';
import { DEFAULT_PREFS, readPrefs, writePrefs } from './prefsStore';
import type { Prefs } from './prefsStore';

export function useSettingsForm() {
  const [theme, setTheme] = useState<string>(DEFAULT_APPEARANCE.theme);
  const [fontSize, setFontSize] = useState(DEFAULT_APPEARANCE.fontSize);
  const [accent, setAccent] = useState(DEFAULT_APPEARANCE.accent);
  const [colorTheme, setColorTheme] = useState(DEFAULT_APPEARANCE.colorTheme);
  const [fontFamily, setFontFamily] = useState(DEFAULT_APPEARANCE.fontFamily);

  const [prefs, setPrefs] = useState<Prefs>(DEFAULT_PREFS);
  const setPref = <K extends keyof Prefs>(k: K, v: Prefs[K]) =>
    setPrefs((p) => ({ ...p, [k]: v }));

  const [hydrated, setHydrated] = useState(false);
  useEffect(() => {
    const a = readAppearance();
    setTheme(a.theme);
    setFontSize(a.fontSize);
    setAccent(a.accent);
    setColorTheme(a.colorTheme);
    setFontFamily(a.fontFamily);
    setPrefs(readPrefs());
    setHydrated(true);
  }, []);

  useEffect(() => {
    if (!hydrated) return;
    writeAppearance({ theme: theme as Appearance['theme'], fontSize, accent, colorTheme, fontFamily });
  }, [hydrated, theme, fontSize, accent, colorTheme, fontFamily]);

  useEffect(() => {
    if (!hydrated) return;
    writePrefs(prefs);
  }, [hydrated, prefs]);

  return {
    theme, setTheme,
    fontSize, setFontSize,
    accent, setAccent,
    colorTheme, setColorTheme,
    fontFamily, setFontFamily,
    ...prefs,
    setLanguage: (v: string) => setPref('language', v),
    setStartup: (v: string) => setPref('startup', v),
    setDefaultModel: (v: string) => setPref('defaultModel', v),
    setLaunchAtLogin: (v: boolean) => setPref('launchAtLogin', v),
    setChatModel: (v: string) => setPref('chatModel', v),
    setEmbedModel: (v: string) => setPref('embedModel', v),
    setContextLength: (v: string) => setPref('contextLength', v),
    setAccelerator: (v: string) => setPref('accelerator', v),
    setGpuLayers: (v: number) => setPref('gpuLayers', v),
    setCpuThreads: (v: number) => setPref('cpuThreads', v),
    setTelemetry: (v: boolean) => setPref('telemetry', v),
    setAnalytics: (v: boolean) => setPref('analytics', v),
    setDataLocation: (v: string) => setPref('dataLocation', v),
    setDatabase: (v: string) => setPref('database', v),
    setDatabaseUrl: (v: string) => setPref('databaseUrl', v),
    setServerPort: (v: string) => setPref('serverPort', v),
  };
}

export type SettingsForm = ReturnType<typeof useSettingsForm>;
