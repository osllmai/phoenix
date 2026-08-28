export type NavItem = {
  key: string;
  label: string;
  href: string;
  icon: string[];
};

export type NavGroup = {
  key: string;
  label: string;
  items: NavItem[];
};

export const navGroups: NavGroup[] = [
  {
    key: 'workspace',
    label: 'Workspace',
    items: [
      { key: 'home', label: 'Home', href: '/', icon: ['M2.5 7.5 8 2.5l5.5 5', 'M4 6.5V13h8V6.5', 'M6.5 13V9.5h3V13'] },
      { key: 'chat', label: 'Chat', href: '/chat', icon: ['M2 3h12v8H6l-3 2.4V11H2z'] },
      { key: 'search', label: 'Search', href: '/deepsearch', icon: ['M7 3a4 4 0 1 0 0 8 4 4 0 0 0 0-8', 'm13 13-2.9-2.9'] },
      { key: 'docs', label: 'Docs', href: '/documents', icon: ['M9 1.8H4.6a1 1 0 0 0-1 1v10.4a1 1 0 0 0 1 1h6.8a1 1 0 0 0 1-1V4.8z', 'M9 1.8V5h3.4'] },
    ],
  },
  {
    key: 'models',
    label: 'Models',
    items: [
      { key: 'models-local', label: 'Local', href: '/models', icon: ['M4.5 4.5h7v7h-7z', 'M6.5 2v2.5M9.5 2v2.5M6.5 11.5V14M9.5 11.5V14M2 6.5h2.5M2 9.5h2.5M11.5 6.5H14M11.5 9.5H14'] },
      { key: 'models-online', label: 'Online', href: '/models/online', icon: ['M4.6 12a2.5 2.5 0 0 1 .3-5 3.5 3.5 0 0 1 6.7 1A2.25 2.25 0 0 1 11.4 12z'] },
      { key: 'models-providers', label: 'Providers', href: '/models/providers', icon: ['M5 8.6a2.4 2.4 0 1 0 0 4.8 2.4 2.4 0 0 0 0-4.8', 'm6.7 9.3 5.3-5.3M10 6l1.6 1.6M8.4 7.6 9.8 9'] },
      { key: 'models-browse', label: 'Browse', href: '/models/browse', icon: ['M8 2.5v6.5', 'm5.2 6.4 2.8 2.8 2.8-2.8', 'M3 13h10'] },
    ],
  },
  {
    key: 'developer',
    label: 'Developer',
    items: [
      { key: 'dev-server', label: 'Server', href: '/developer', icon: ['M2.5 3h11v3.8h-11z', 'M2.5 9.2h11v3.8h-11z', 'M5 4.9h.01M5 11.1h.01'] },
      { key: 'dev-maestro', label: 'Maestro', href: '/developer/maestro', icon: ['M2.5 5h6M11 5h2.5M2.5 11h2M7 11h6.5', 'M9.5 3.4a1.6 1.6 0 1 0 0 3.2 1.6 1.6 0 0 0 0-3.2', 'M4.5 9.4a1.6 1.6 0 1 0 0 3.2 1.6 1.6 0 0 0 0-3.2'] },
      { key: 'dev-flows', label: 'Flows', href: '/developer/flows', icon: ['M4 2.2a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3', 'M4 10.8a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3', 'M11.7 6.5a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3', 'M4 5.2v5.6M5.4 4.6c4 .6 4.5 2 4.8 2.6'] },
      { key: 'dev-evaluators', label: 'Evaluators', href: '/developer/evaluators', icon: ['M2 13h12', 'M4.5 13V8M8 13V4M11.5 13V6.5'] },
    ],
  },
  {
    key: 'tools',
    label: 'Tools',
    items: [
      { key: 'speech', label: 'Speech', href: '/speech', icon: ['M6 2h4v7H6z', 'M4 7.4a4 4 0 0 0 8 0M8 11.4V14'] },
      { key: 'forecasting', label: 'Forecasting', href: '/forecasting', icon: ['M2 13h12', 'M2.5 10.5 6 7l2.5 2L13.5 4', 'M10.5 4h3v3'] },
      { key: 'extensions', label: 'Extensions', href: '/extensions', icon: ['M2 2h5v5H2z', 'M9 2h5v5H9z', 'M2 9h5v5H2z', 'M11.5 9.2v4.6M9.2 11.5h4.6'] },
    ],
  },
];

export const footerItem: NavItem = {
  key: 'settings',
  label: 'Settings',
  href: '/settings',
  icon: ['M8 6a2 2 0 1 0 0 4 2 2 0 0 0 0-4', 'M8 1.6v2.2M8 12.2v2.2M1.6 8h2.2M12.2 8h2.2M3.5 3.5l1.5 1.5M11 11l1.5 1.5M3.5 12.5 5 11M11 5l1.5-1.5'],
};

export const newMenuItems: NavItem[] = [
  { key: 'new-chat', label: 'New chat', href: '/chat', icon: ['M2 3h12v8H6l-3 2.4V11H2z'] },
  { key: 'new-doc', label: 'Add document', href: '/documents', icon: ['M9 1.8H4.6a1 1 0 0 0-1 1v10.4a1 1 0 0 0 1 1h6.8a1 1 0 0 0 1-1V4.8z', 'M9 1.8V5h3.4', 'M8 7.6v3.4M6.3 9.3h3.4'] },
  { key: 'new-model', label: 'Download model', href: '/models/browse', icon: ['M8 2.5v6.5', 'm5.2 6.4 2.8 2.8 2.8-2.8', 'M3 13h10'] },
  { key: 'new-flow', label: 'New flow', href: '/developer/flows', icon: ['M4 2.2a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3', 'M11.7 6.5a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3', 'M5.4 4.6c4 .6 4.5 2 4.8 2.6'] },
];

export function gatewayLabel(): string {
  const base = process.env.NEXT_PUBLIC_API_BASE_URL;
  if (!base) return 'On-device';
  return `On-device · :${new URL(base).port || '80'}`;
}
