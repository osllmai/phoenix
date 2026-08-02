'use client';

import { THEMES } from './themes';
import s from '../page.module.css';

export function ThemeGallery({
  value,
  onChange,
}: {
  value: string;
  onChange: (id: string) => void;
}) {
  return (
    <div className={s.themeGrid}>
      {THEMES.map((t) => {
        const c = t.dark;
        return (
          <button
            key={t.id}
            type="button"
            aria-label={t.name}
            className={`${s.themeCard} ${value === t.id ? s.sel : ''}`}
            onClick={() => onChange(t.id)}
          >
            <span
              className={s.themePreview}
              style={c ? { background: c.bg } : undefined}
            >
              <span
                className={s.themeDot}
                style={c ? { background: c.accent } : undefined}
              />
              <span
                className={s.themeStrip}
                style={c ? { background: c.surface } : undefined}
              />
            </span>
            <span className={s.themeName}>{t.name}</span>
          </button>
        );
      })}
    </div>
  );
}
