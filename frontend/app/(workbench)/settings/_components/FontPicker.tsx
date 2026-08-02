'use client';

import { useEffect, useMemo, useRef, useState } from 'react';

import { FONT_FAMILIES } from './appearanceStore';
import { GOOGLE_FONT_NAMES, isBundled, loadGoogleFont } from './googleFonts';
import s from './fontPicker.module.css';

const ALL_FONTS = [...FONT_FAMILIES, ...GOOGLE_FONT_NAMES];

function FontRow({
  font,
  selected,
  onPick,
}: {
  font: string;
  selected: boolean;
  onPick: (f: string) => void;
}) {
  const [ready, setReady] = useState(isBundled(font));
  useEffect(() => {
    if (isBundled(font)) return;
    let live = true;
    loadGoogleFont(font)
      .then(() => live && setReady(true))
      .catch(() => undefined);
    return () => {
      live = false;
    };
  }, [font]);

  return (
    <button
      type="button"
      className={`${s.fontRow} ${selected ? s.sel : ''}`}
      style={{ fontFamily: ready ? `'${font}', system-ui, sans-serif` : undefined }}
      onClick={() => onPick(font)}
    >
      {font}
    </button>
  );
}

export function FontPicker({
  value,
  onChange,
}: {
  value: string;
  onChange: (v: string) => void;
}) {
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState('');
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!open) return;
    const onDoc = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
    };
    document.addEventListener('mousedown', onDoc);
    return () => document.removeEventListener('mousedown', onDoc);
  }, [open]);

  const results = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return ALL_FONTS;
    return ALL_FONTS.filter((f) => f.toLowerCase().includes(q));
  }, [query]);

  const pick = (f: string) => {
    onChange(f);
    setOpen(false);
    setQuery('');
  };

  return (
    <div className={s.fontPicker} ref={ref}>
      <button
        type="button"
        className={s.fontTrigger}
        style={{ fontFamily: `'${value}', system-ui, sans-serif` }}
        onClick={() => setOpen((o) => !o)}
        aria-haspopup="listbox"
        aria-expanded={open}
      >
        {value}
        <span className={s.fontCaret}>▾</span>
      </button>
      {open && (
        <div className={s.fontPanel}>
          <input
            className={s.fontSearch}
            type="text"
            placeholder="Search Google Fonts…"
            value={query}
            autoFocus
            onChange={(e) => setQuery(e.target.value)}
          />
          <div className={s.fontList} role="listbox">
            {results.length === 0 ? (
              <div className={s.fontEmpty}>No fonts match “{query}”.</div>
            ) : (
              results.map((f) => (
                <FontRow key={f} font={f} selected={f === value} onPick={pick} />
              ))
            )}
          </div>
        </div>
      )}
    </div>
  );
}
