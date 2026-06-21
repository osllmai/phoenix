'use client';

import { useState } from 'react';
import Link from 'next/link';

import type { NavGroup } from '@/lib/nav';
import NavIcon from './NavIcon';
import s from './Sidebar.module.css';

export default function SidebarGroup({
  group,
  isActive,
}: {
  group: NavGroup;
  isActive: (href: string) => boolean;
}) {
  const [collapsed, setCollapsed] = useState(false);

  return (
    <div className={`${s.group} ${collapsed ? s.collapsed : ''}`}>
      <button
        className={s.head}
        aria-expanded={!collapsed}
        onClick={() => setCollapsed((v) => !v)}
      >
        <span className={s.headT}>{group.label}</span>
        <span className={s.headCaret}>▾</span>
      </button>
      <div className={s.items}>
        {group.items.map((item) => (
          <Link
            key={item.key}
            href={item.href}
            className={`${s.link} ${isActive(item.href) ? s.active : ''}`}
          >
            <NavIcon paths={item.icon} className={s.ico} />
            <span className={s.label}>{item.label}</span>
          </Link>
        ))}
      </div>
    </div>
  );
}
