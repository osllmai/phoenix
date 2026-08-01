'use client';

import { useState } from 'react';

import s from '../page.module.css';
import rail from './convosRail.module.css';
import { SAMPLE_CONVOS } from './data';

type Props = { collapsed: boolean; onToggle: () => void };

function ConvosRail({ onToggle }: { onToggle: () => void }) {
  return (
    <aside className={rail.rail}>
      <button className={`${rail.railIcon} ${rail.railNew}`} title="New chat">
        ＋
      </button>
      <button className={rail.railIcon} title="Search conversations">
        🔍
      </button>
      {SAMPLE_CONVOS.map((c) => (
        <div
          key={c.id}
          className={`${rail.railAvatar} ${c.selected ? rail.railAvatarSel : ''}`}
          title={c.title}
        >
          {c.title.charAt(0)}
          {c.pinned && <span className={rail.railPin}>📌</span>}
        </div>
      ))}
      <div className={rail.railSep} />
      <button
        className={`${rail.railIcon} ${rail.railExpand}`}
        title="Expand list"
        onClick={onToggle}
      >
        »
      </button>
    </aside>
  );
}

export default function ConvosSidebar({ collapsed, onToggle }: Props) {
  const [q, setQ] = useState('');

  if (collapsed) return <ConvosRail onToggle={onToggle} />;

  const ql = q.trim().toLowerCase();
  const convos = SAMPLE_CONVOS.filter(
    (c) => ql === '' || c.title.toLowerCase().includes(ql) || c.snippet.toLowerCase().includes(ql),
  );

  const groups: string[] = [];
  for (const c of convos) if (!groups.includes(c.group)) groups.push(c.group);

  return (
    <aside className={s.convos}>
      <header className={s.convosHead}>
        <div className={s.convosHeadRow}>
          <button className={s.newchat}>＋ New chat</button>
          <button className={s.collapse} title="Collapse list" onClick={onToggle}>
            «
          </button>
        </div>
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
