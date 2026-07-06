'use client';

import { usePathname } from 'next/navigation';

import { pageTitle } from '@/lib/mobileNav';
import NavIcon from './NavIcon';
import s from './AppBar.module.css';

export default function AppBar({ onMenu }: { onMenu: () => void }) {
  const title = pageTitle(usePathname());

  return (
    <header className={s.bar}>
      <img className={s.logo} src="/phoenix-ember.svg" alt="Phoenix" />
      <span className={s.title}>{title}</span>
      <button className={s.act} onClick={onMenu} aria-label="Open menu">
        <NavIcon paths={['M2 4h12', 'M2 8h12', 'M2 12h12']} className={s.ico} />
      </button>
    </header>
  );
}
