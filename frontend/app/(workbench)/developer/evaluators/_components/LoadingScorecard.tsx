import { Skeleton } from '@/app/components/ui';
import s from '../page.module.css';

const ROWS = [
  { label: '60%', track: '100%' },
  { label: '48%', track: '42%' },
  { label: '54%', track: '70%' },
  { label: '44%', track: '85%' },
];

export default function LoadingScorecard() {
  return (
    <div className={s.wrap}>
      <div className={s.loadingHint}>Running evaluation… indoxJudge · llama-3.1-8b</div>
      <div className={s.scorecard}>
        {ROWS.map((row, i) => (
          <div key={i} className={s.skelMeter}>
            <Skeleton width={row.label} height={12} />
            <Skeleton width={row.track} height={7} radius="var(--r-pill)" />
            <Skeleton width={36} height={10} />
          </div>
        ))}
      </div>
    </div>
  );
}
