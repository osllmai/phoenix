'use client';

import { useState } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';

import { GATEWAY_LABEL, footerItem, navGroups, newMenuItems } from '@/lib/nav';
import NavIcon from './NavIcon';
import SidebarGroup from './SidebarGroup';
import s from './Sidebar.module.css';

export default function Sidebar() {
  const pathname = usePathname();
  const [menuOpen, setMenuOpen] = useState(false);

  const isActive = (href: string) =>
    href === '/' ? pathname === '/' : pathname === href || pathname.startsWith(`${href}/`);

  return (
    <nav className={s.sb} aria-label="Primary">
      <div className={s.brand}>
        <img className={s.logo} src="/phoenix-ember.svg" alt="Phoenix" />
        <span className={s.word}>Phoenix</span>
      </div>

      <div className={s.top}>
        <div className={s.newWrap}>
          <button
            className={s.new}
            aria-haspopup="true"
            aria-expanded={menuOpen}
            onClick={() => setMenuOpen((v) => !v)}
            onBlur={() => setMenuOpen(false)}
          >
            <span className={s.newIco}>+</span>
            <span className={s.newT}>New</span>
            <span className={s.caret}>▾</span>
          </button>
          {menuOpen && (
            <div className={s.menu}>
              {newMenuItems.map((item) => (
                <Link key={item.key} href={item.href} onMouseDown={(e) => e.preventDefault()}>
                  <NavIcon paths={item.icon} className={s.mico} />
                  {item.label}
                </Link>
              ))}
            </div>
          )}
        </div>
        <button className={s.search} title="Search (Cmd+K)">
          <NavIcon paths={['M7 3a4 4 0 1 0 0 8 4 4 0 0 0 0-8', 'm13 13-2.9-2.9']} className={s.searchIco} />
          <span className={s.searchT}>Search…</span>
          <span className={s.kbd}>⌘K</span>
        </button>
      </div>

      <div className={s.scroll}>
        {navGroups.map((group) => (
          <SidebarGroup key={group.key} group={group} isActive={isActive} />
        ))}
      </div>

      <div className={s.foot}>
        <Link
          href={footerItem.href}
          className={`${s.link} ${isActive(footerItem.href) ? s.active : ''}`}
        >
          <NavIcon paths={footerItem.icon} className={s.ico} />
          <span className={s.label}>{footerItem.label}</span>
        </Link>
        <div className={s.status} title="Local server running">
          <span className={s.statusDot} />
          <span>{GATEWAY_LABEL}</span>
        </div>
      </div>
    </nav>
  );
}
