'use client';

import { Button, Skeleton } from '@/app/components/ui';

import InputPanel from './InputPanel';
import { LOADING_SEGMENTS } from './sampleData';
import s from '../page.module.css';

export default function LoadingView({ onCancel }: { onCancel: () => void }) {
  return (
    <div className={s.split}>
      <InputPanel state="loading">
        <div className={s.csec}>
          <div className={s.clabel}>Backend ASR job</div>
          <div className={s.jobLine}>
            Whisper small · <strong className={s.warnInk}>47%</strong> · est. 9s left
          </div>
          <div className={s.ptrack}>
            <div className={s.pfill} />
          </div>
          <div className={s.chips} style={{ marginTop: 'var(--sp-3)' }}>
            <span className={`${s.chip} ${s.amber}`}>on-device</span>
            <span className={s.chip}>queued via Celery</span>
          </div>
          <div className={s.jobCancel}>
            <Button variant="ghost" onClick={onCancel}>Cancel</Button>
            <Button variant="ghost">Run in background</Button>
          </div>
        </div>
      </InputPanel>

      <div className={s.output}>
        <div className={s.outputTop}>
          <h2 className={s.outputTitle}>Transcript — transcribing…</h2>
        </div>
        <div className={s.scroll}>
          {LOADING_SEGMENTS.map((seg) => (
            <div className={s.segment} key={seg.start}>
              <span className={s.segMeta}>
                <span className={`${s.segTime} ${s.segTimeDim}`}>
                  {seg.start} → {seg.end}
                </span>
              </span>
              <span className={s.segText}>
                {seg.widths.map((w, i) => (
                  <Skeleton key={w} width={w} height={12} className={i > 0 ? s.skelGap : undefined} />
                ))}
              </span>
            </div>
          ))}
          <div className={s.liveNote}>
            <span className={s.pulse}>⏳</span> Segments appear as they complete…
          </div>
        </div>
      </div>
    </div>
  );
}
