'use client';

import { useState } from 'react';

import { PALETTE_GROUPS } from './sampleData';
import s from '../page.module.css';

export default function Palette() {
  const [query, setQuery] = useState('');
  const q = query.trim().toLowerCase();

  const groups = PALETTE_GROUPS.map((g) => ({
    ...g,
    items: q === '' ? g.items : g.items.filter((i) => i.label.toLowerCase().includes(q)),
  })).filter((g) => g.items.length > 0);

  return (
    <aside className={s.palette}>
      <input
        className={s.palSearch}
        placeholder="Search nodes…"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
      />
      {groups.map((group) => (
        <div key={group.heading} className={s.palGrp}>
          <h4>{group.heading}</h4>
          {group.items.map((item) => (
            <div key={item.label} className={s.chip}>
              <span className={s.ci}>{item.icon}</span> {item.label}
              <span className={s.grip}>⠿</span>
            </div>
          ))}
        </div>
      ))}
      {groups.length === 0 && <p className={s.noMatch}>No nodes match.</p>}
    </aside>
  );
}
