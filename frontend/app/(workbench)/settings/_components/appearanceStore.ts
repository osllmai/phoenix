'use client';

import { BUNDLED_FONTS, isBundled, loadGoogleFont } from './googleFonts';
import { THEMES, THEME_VARS } from './themes';
import type { ThemeColors } from './themes';

export type Appearance = {
  theme: 'Dark' | 'Light' | 'System';
  fontSize: number;
  accent: string;
  colorTheme: string;
  fontFamily: string;
};

export const APPEARANCE_KEY = 'phoenix.settings';
export const APPEARANCE_EVENT = 'phoenix:appearance';
export const FONT_NOTICE_EVENT = 'phoenix:font-notice';

function dispatchFontNotice(family: string): void {
  if (typeof window === 'undefined') return;
  window.dispatchEvent(new CustomEvent(FONT_NOTICE_EVENT, { detail: { family } }));
}

export const DEFAULT_APPEARANCE: Appearance = {
  theme: 'Dark',
  fontSize: 15,
  accent: 'ember',
  colorTheme: 'phoenix',
  fontFamily: 'DM Sans',
};

const SANS = '-apple-system, system-ui, sans-serif';
const SERIF = 'Georgia, serif';

export const FONT_FAMILIES: readonly string[] = [...BUNDLED_FONTS];

const FONT_STACKS: Record<string, { body: string; display: string }> = {
  'DM Sans': { body: `'DM Sans', ${SANS}`, display: `'Lora', ${SERIF}` },
  Inter: { body: `'Inter', ${SANS}`, display: `'Inter', ${SANS}` },
  Lora: { body: `'Lora', ${SERIF}`, display: `'Lora', ${SERIF}` },
  Merriweather: { body: `'Merriweather', ${SERIF}`, display: `'Merriweather', ${SERIF}` },
  'Playfair Display': { body: `'Playfair Display', ${SERIF}`, display: `'Playfair Display', ${SERIF}` },
  OpenDyslexic: { body: `'OpenDyslexic', ${SANS}`, display: `'OpenDyslexic', ${SANS}` },
};

export const ACCENT_HEX: Record<string, string> = {
  ember: '#FF8A3D',
  sage: '#6FB585',
  sky: '#6E9CB5',
  plum: '#A98FC2',
  gold: '#E8C24A',
};

export function readAppearance(): Appearance {
  if (typeof window === 'undefined') return DEFAULT_APPEARANCE;
  try {
    const raw = window.localStorage.getItem(APPEARANCE_KEY);
    if (!raw) return DEFAULT_APPEARANCE;
    const stored = { ...DEFAULT_APPEARANCE, ...JSON.parse(raw) };
    if ((stored.theme as string) === 'Cream') stored.theme = 'Light';
    return stored;
  } catch {
    return DEFAULT_APPEARANCE;
  }
}

export function writeAppearance(value: Appearance): void {
  if (typeof window === 'undefined') return;
  window.localStorage.setItem(APPEARANCE_KEY, JSON.stringify(value));
  window.dispatchEvent(new CustomEvent(APPEARANCE_EVENT));
}

function resolveLight(theme: Appearance['theme']): boolean {
  if (theme === 'Light') return true;
  if (theme === 'Dark') return false;
  return window.matchMedia('(prefers-color-scheme: light)').matches;
}

function applyThemeOverride(c: ThemeColors): void {
  const root = document.documentElement;
  root.style.setProperty('--accent-primary', c.accent);
  root.style.setProperty('--accent-hover', c.accent);
  root.style.setProperty('--accent-subtle', `${c.accent}22`);
  root.style.setProperty('--accent-ink', c.accent);
  root.style.setProperty('--bg-primary', c.bg);
  root.style.setProperty('--bg-secondary', c.bg);
  root.style.setProperty('--surface-card', c.surface);
  root.style.setProperty('--text-primary', c.text);
  root.style.setProperty('--text-secondary', c.textSecondary);
  root.style.setProperty('--border-default', c.divider);
}

function clearThemeOverride(): void {
  const root = document.documentElement;
  for (const v of THEME_VARS) root.style.removeProperty(v);
}

export function applyAppearance(value: Appearance): void {
  if (typeof document === 'undefined') return;
  const root = document.documentElement;
  const light = resolveLight(value.theme);
  if (light) root.dataset.theme = 'light';
  else delete root.dataset.theme;

  const theme = THEMES.find((t) => t.id === value.colorTheme);
  const colors = theme ? (light ? theme.light : theme.dark) : null;

  if (colors) {
    applyThemeOverride(colors);
  } else {
    clearThemeOverride();
    const hex = ACCENT_HEX[value.accent] ?? ACCENT_HEX.ember;
    root.style.setProperty('--accent-primary', hex);
    root.style.setProperty('--accent-hover', hex);
    root.style.setProperty('--accent-subtle', `${hex}22`);
    root.style.setProperty('--accent-ink', hex);
  }

  root.style.setProperty('--fs-base', `${value.fontSize}px`);
  applyFont(value.fontFamily);
}

function setFontStack(family: string): void {
  const root = document.documentElement;
  const stack = FONT_STACKS[family];
  if (stack) {
    root.style.setProperty('--font-body', stack.body);
    root.style.setProperty('--font-display', stack.display);
    return;
  }
  const custom = `'${family}', system-ui, sans-serif`;
  root.style.setProperty('--font-body', custom);
  root.style.setProperty('--font-display', custom);
}

function applyFont(family: string): void {
  if (isBundled(family)) {
    setFontStack(family);
    return;
  }
  loadGoogleFont(family)
    .then(() => setFontStack(family))
    .catch(() => {
      const fallback = readAppearance();
      const safe = isBundled(fallback.fontFamily) ? fallback.fontFamily : DEFAULT_APPEARANCE.fontFamily;
      writeAppearance({ ...fallback, fontFamily: safe });
      setFontStack(safe);
      dispatchFontNotice(family);
    });
}
