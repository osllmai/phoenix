'use client';

import { SECTIONS } from '../sample';
import s from '../page.module.css';

export default function SettingsNav({
  active,
  onSelect,
  query,
  onQuery,
  searchable = true,
  foot,
}: {
  active: string;
  onSelect: (id: string) => void;
  query?: string;
  onQuery?: (q: string) => void;
  searchable?: boolean;
  foot?: string;
}) {
  const q = (query ?? '').trim().toLowerCase();
  return (
    <nav className={s.nav} aria-label="Settings sections">
      <div className={s.navTitle}>Settings</div>
      {searchable && (
        <div className={s.navSearch}>
          <input
            type="text"
            value={query ?? ''}
            onChange={(e) => onQuery?.(e.target.value)}
            placeholder="Search settings…"
            aria-label="Search settings"
          />
          <span className={s.kbd}>/</span>
        </div>
      )}
      {SECTIONS.map((sec) => {
        const dim = q !== '' && !sec.label.toLowerCase().includes(q);
        return (
          <button
            key={sec.id}
            type="button"
            className={`${s.navLink} ${active === sec.id ? s.active : ''} ${dim ? s.dim : ''}`}
            onClick={() => onSelect(sec.id)}
          >
            <span className={s.nico}>{sec.icon}</span>
            {sec.label}
          </button>
        );
      })}
      <span className={s.navSpacer} />
      {foot != null && <div className={s.navFoot}>{foot}</div>}
    </nav>
  );
}
