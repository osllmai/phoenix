'use client';

import { PageHeader } from '@/app/components/ui';

import s from '../page.module.css';

const TOGGLES = ['Quantiles', 'Normalize', 'Covariates'] as const;

export default function ForecastHeader({
  toggles,
  onToggle,
}: {
  toggles: Record<string, boolean>;
  onToggle: (key: string) => void;
}) {
  return (
    <PageHeader title="📈 Forecasting">
      <div className={s.sep} />
      <div className={s.picker}>
        <label>Model</label>
        <select defaultValue="2.5">
          <option value="2.5">TimesFM 2.5 (200M · 16K ctx)</option>
          <option value="2.0">TimesFM 2.0 (500M · 2K ctx)</option>
        </select>
      </div>
      <div className={s.picker}>
        <label>Horizon</label>
        <select defaultValue="24">
          <option value="12">12 steps</option>
          <option value="24">24 steps</option>
          <option value="96">96 steps</option>
          <option value="custom">Custom…</option>
        </select>
      </div>
      <div className={s.sep} />
      {TOGGLES.map((t) => (
        <button
          key={t}
          type="button"
          className={`${s.toggle} ${toggles[t] ? s.toggleOn : ''}`}
          onClick={() => onToggle(t)}
        >
          {t}
        </button>
      ))}
    </PageHeader>
  );
}
