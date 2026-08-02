export type ThemeColors = {
  accent: string;
  bg: string;
  surface: string;
  text: string;
  textSecondary: string;
  divider: string;
};

export type ThemeDef = {
  id: string;
  name: string;
  light: ThemeColors | null;
  dark: ThemeColors | null;
};

export const THEMES: ThemeDef[] = [
  { id: 'phoenix', name: 'Phoenix', light: null, dark: null },
  {
    id: 'copper',
    name: 'Copper',
    light: { accent: '#B87333', bg: '#FFFBF7', surface: '#FAF5EF', text: '#1C1210', textSecondary: '#78716C', divider: '#F5F0EB' },
    dark: { accent: '#D4915A', bg: '#110E0C', surface: '#1A1614', text: '#F5F0EB', textSecondary: '#A8A29E', divider: '#302824' },
  },
  {
    id: 'indox',
    name: 'Indox',
    light: { accent: '#1F3AB3', bg: '#FBFBFF', surface: '#FBFBFF', text: '#252525', textSecondary: '#434D5A', divider: '#CDD0D8' },
    dark: { accent: '#4989FF', bg: '#081125', surface: '#0C204E', text: '#FFFFFF', textSecondary: '#9BA3AE', divider: '#1A3B8B' },
  },
  {
    id: 'obsidian',
    name: 'Obsidian',
    light: { accent: '#334155', bg: '#FFFFFF', surface: '#F1F5F9', text: '#0F172A', textSecondary: '#64748B', divider: '#E2E8F0' },
    dark: { accent: '#94A3B8', bg: '#0F172A', surface: '#1E293B', text: '#F1F5F9', textSecondary: '#94A3B8', divider: '#334155' },
  },
  {
    id: 'indigo',
    name: 'Indigo',
    light: { accent: '#4F46E5', bg: '#FFFFFF', surface: '#F5F5FA', text: '#1E1B4B', textSecondary: '#6366F1', divider: '#EEF2FF' },
    dark: { accent: '#818CF8', bg: '#0F0F1A', surface: '#1A1840', text: '#E0E7FF', textSecondary: '#A5B4FC', divider: '#312E81' },
  },
  {
    id: 'studio',
    name: 'Studio',
    light: { accent: '#6C5CE7', bg: '#FFFFFF', surface: '#F8F9FA', text: '#111827', textSecondary: '#6B7280', divider: '#F3F4F6' },
    dark: { accent: '#8B7CF6', bg: '#0F0F0F', surface: '#1A1A1A', text: '#F9FAFB', textSecondary: '#9CA3AF', divider: '#2D2D2D' },
  },
  {
    id: 'pencilly',
    name: 'Pencilly',
    light: { accent: '#5B4FCF', bg: '#F8F8FC', surface: '#FFFFFF', text: '#1A1A2E', textSecondary: '#8888AA', divider: '#EBEBF5' },
    dark: { accent: '#8B7FE8', bg: '#0F0F1A', surface: '#1A1A2E', text: '#F0F0FF', textSecondary: '#9999BB', divider: '#2A2A4A' },
  },
  {
    id: 'news',
    name: 'News',
    light: { accent: '#475AD7', bg: '#FFFFFF', surface: '#F3F4F6', text: '#333647', textSecondary: '#7C82A1', divider: '#F1F2F6' },
    dark: { accent: '#475AD7', bg: '#22242F', surface: '#333647', text: '#F3F4F6', textSecondary: '#ACAFC3', divider: '#44485F' },
  },
];

export const THEME_VARS = [
  '--accent-primary',
  '--accent-hover',
  '--accent-subtle',
  '--accent-ink',
  '--bg-primary',
  '--bg-secondary',
  '--surface-card',
  '--text-primary',
  '--text-secondary',
  '--border-default',
] as const;
