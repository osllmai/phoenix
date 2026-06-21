'use client';

import { useState } from 'react';

import s from '../page.module.css';
import { SAMPLE_CONVOS } from './data';

export default function ConvosSidebar() {
  const [q, setQ] = useState('');
  const ql = q.trim().toLowerCase();
  const convos = SAMPLE_CONVOS.filter(
    (c) => ql === '' || c.title.toLowerCase().includes(ql) || c.snippet.toLowerCase().includes(ql),
  );

  const groups: string[] = [];
  for (const c of convos) if (!groups.includes(c.group)) groups.push(c.group);

  return (
    <aside className={s.convos}>
      <header className={s.convosHead}>
        <button className={s.newchat}>＋ New chat</button>
        <input
          className={s.search}
          placeholder="Search conversations…"
          value={q}
          onChange={(e) => setQ(e.target.value)}
        />
      </header>
      <div className={s.convosScroll}>
        {groups.map((g) => (
          <div key={g}>
            <div className={s.grouplabel}>{g}</div>
            {convos
              .filter((c) => c.group === g)
              .map((c) => (
                <div key={c.id} className={`${s.convo} ${c.selected ? s.convoSel : ''}`}>
                  <div className={s.convoT}>
                    <span className={s.convoTitle}>{c.title}</span>
                    {c.pinned ? (
                      <span className={s.pin}>📌</span>
                    ) : (
                      <span className={s.convoTime}>{c.time}</span>
                    )}
                  </div>
                  <div className={s.convoSnip}>{c.snippet}</div>
                </div>
              ))}
          </div>
        ))}
        {convos.length === 0 && <div className={s.grouplabel}>No matches</div>}
      </div>
    </aside>
  );
}
