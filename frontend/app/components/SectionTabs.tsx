'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';

import type { SectionTab } from './sectionTabs.config';
import s from './SectionTabs.module.css';

type Props = {
  items: SectionTab[];
  variant?: 'pill' | 'tab';
  'aria-label'?: string;
};

export default function SectionTabs({ items, variant = 'pill', ...rest }: Props) {
  const pathname = usePathname();

  return (
    <nav className={variant === 'tab' ? s.tab : s.pill} aria-label={rest['aria-label']}>
      {items.map((item) => {
        const active = pathname === item.href;
        return (
          <Link
            key={item.href}
            href={item.href}
            className={`${s.link} ${active ? s.active : ''}`}
            aria-current={active ? 'page' : undefined}
          >
            {item.label}
          </Link>
        );
      })}
    </nav>
  );
}
