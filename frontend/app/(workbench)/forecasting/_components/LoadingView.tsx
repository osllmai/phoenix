'use client';

import { Button, Skeleton } from '@/app/components/ui';

import s from '../page.module.css';

export default function LoadingView({ onCancel }: { onCancel: () => void }) {
  return (
    <div className={s.split}>
      <aside className={s.ctrl}>
        <div className={s.csec}>
          <div className={s.clabel}>Backend forecast job</div>
          <div className={s.jobLine}>
            TimesFM 2.5 · <strong className={s.running}>running</strong> · est. 2s left
          </div>
          <div className={s.ptrack}>
            <div className={s.pfill} />
          </div>
          <div className={s.chipsTop}>
            <span className={`${s.chip} ${s.amber}`}>on-device</span>
            <span className={s.chip}>queued via Celery</span>
            <span className={s.chip}>CPU</span>
          </div>
          <div className={s.btnGap}>
            <Button variant="ghost" onClick={onCancel}>
              Cancel
            </Button>
            <Button variant="ghost">Run in background</Button>
          </div>
        </div>
      </aside>
      <section className={s.output}>
        <div className={s.outputTop}>
          <h2 className={s.outputTitle}>Forecast — running…</h2>
        </div>
        <div className={s.scroll}>
          <div className={s.chartwrap}>
            <Skeleton width="100%" height={230} radius="var(--r-md)" />
          </div>
          <div className={s.encoding}>
            <span className={s.pulse}>⏳</span>
            Encoding context · sampling quantiles…
          </div>
        </div>
      </section>
    </div>
  );
}
