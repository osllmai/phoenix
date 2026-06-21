export type SectionTab = { label: string; href: string };

export const DEV_TABS: SectionTab[] = [
  { label: 'Server', href: '/developer' },
  { label: 'Maestro', href: '/developer/maestro' },
  { label: 'Flows', href: '/developer/flows' },
  { label: 'Evaluators', href: '/developer/evaluators' },
];

export const MODELS_TABS: SectionTab[] = [
  { label: 'Local', href: '/models' },
  { label: 'Online', href: '/models/online' },
  { label: 'Providers', href: '/models/providers' },
  { label: 'Browse', href: '/models/browse' },
];
