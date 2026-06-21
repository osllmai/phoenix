'use client';

import Link from 'next/link';

import { CenterState } from '@/app/components/ui';

import { SAMPLE_RESULT } from './sampleData';
import s from '../page.module.css';

export default function SuccessView({ name }: { name: string }) {
  const label = name.trim() || SAMPLE_RESULT.name;
  return (
    <CenterState icon="✅" title="Model added">
      <div className={s.successCard}>
        <span className={s.scIco}>🧠</span>
        <div>
          <div className={s.scName}>Added “{label}” to your catalog</div>
          <div className={s.scSub}>{SAMPLE_RESULT.sub}</div>
        </div>
      </div>
      <div className={s.ctaRow}>
        <Link className={s.ctaPrimary} href="/chat">
          Load &amp; open chat
        </Link>
        <Link className={s.cancel} href="/models">
          Back to models
        </Link>
      </div>
    </CenterState>
  );
}
