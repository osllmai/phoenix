import { footerItem, navGroups, type NavItem } from './nav';

export const bottomNavItems: NavItem[] = [
  { key: 'home', label: 'Home', href: '/', icon: ['M2.5 7.5 8 2.5l5.5 5', 'M4 6.5V13h8V6.5', 'M6.5 13V9.5h3V13'] },
  { key: 'chat', label: 'Chat', href: '/chat', icon: ['M2 3h12v8H6l-3 2.4V11H2z'] },
  { key: 'models', label: 'Models', href: '/models', icon: ['M4.5 4.5h7v7h-7z', 'M6.5 2v2.5M9.5 2v2.5M6.5 11.5V14M9.5 11.5V14M2 6.5h2.5M2 9.5h2.5M11.5 6.5H14M11.5 9.5H14'] },
  { key: 'docs', label: 'Docs', href: '/documents', icon: ['M9 1.8H4.6a1 1 0 0 0-1 1v10.4a1 1 0 0 0 1 1h6.8a1 1 0 0 0 1-1V4.8z', 'M9 1.8V5h3.4'] },
];

const allItems: NavItem[] = [...navGroups.flatMap((g) => g.items), footerItem];

export function pageTitle(pathname: string): string {
  const match = allItems
    .filter((i) => (i.href === '/' ? pathname === '/' : pathname === i.href || pathname.startsWith(`${i.href}/`)))
    .sort((a, b) => b.href.length - a.href.length)[0];
  return match?.label ?? 'Phoenix';
}
