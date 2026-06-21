'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';

import { bottomNavItems } from '@/lib/mobileNav';
import NavIcon from './NavIcon';
import s from './BottomNav.module.css';

export default function BottomNav({ onMore }: { onMore: () => void }) {
  const pathname = usePathname();
  const isActive = (href: string) =>
    href === '/' ? pathname === '/' : pathname === href || pathname.startsWith(`${href}/`);
  const onPrimary = bottomNavItems.some((i) => isActive(i.href));

  return (
    <nav className={s.bar} aria-label="Primary mobile">
      {bottomNavItems.map((item) => (
        <Link
          key={item.key}
          href={item.href}
          className={`${s.item} ${isActive(item.href) ? s.active : ''}`}
        >
          <NavIcon paths={item.icon} className={s.ico} />
          <span>{item.label}</span>
        </Link>
      ))}
      <button
        className={`${s.item} ${onPrimary ? '' : s.active}`}
        onClick={onMore}
        aria-label="More"
      >
        <NavIcon paths={['M3.5 8h.01', 'M8 8h.01', 'M12.5 8h.01']} className={s.ico} />
        <span>More</span>
      </button>
    </nav>
  );
}
