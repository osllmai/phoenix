'use client';

import { Card, CardHead } from '@/app/components/ui';

import type { ModelDetail } from './sample';
import s from '../page.module.css';

export default function SpecsCard({ model }: { model: ModelDetail }) {
  return (
    <Card>
      <CardHead title="Parameters" />
      <dl className={s.specRows}>
        {model.parameters.map((p) => (
          <div key={p.label} className={s.specRow}>
            <dt>{p.label}</dt>
            <dd>{p.value}</dd>
          </div>
        ))}
      </dl>

      <div className={s.specDivider} />

      <CardHead title="Benchmarks" />
      <div className={s.benchGrid}>
        {model.benchmarks.map((b) => (
          <div key={b.label} className={s.benchCell}>
            <div className={s.benchValue}>{b.value}</div>
            <div className={s.benchLabel}>{b.label}</div>
          </div>
        ))}
      </div>
    </Card>
  );
}
