import { Button, Skeleton } from '@/app/components/ui';

import PlanTimeline from './PlanTimeline';
import { LOADING_STEPS } from './sampleData';
import s from '../page.module.css';

const SKELETONS: number[][] = [
  [70, 40, 100, 88],
  [60, 35, 100, 75],
  [80, 45, 100, 92],
];

export default function LoadingView({ onCancel }: { onCancel: () => void }) {
  return (
    <>
      <div className={`${s.plan} ${s.planLoading}`}>
        <div className={s.planHead}>
          <span className={s.planTtl}>Research in progress</span>
        </div>
        <PlanTimeline steps={LOADING_STEPS} />
      </div>
      <div className={s.loadingNote}>Reading 34 sources — ranking by semantic similarity…</div>
      <div className={s.jobControls}>
        <Button variant="ghost" onClick={onCancel}>
          Cancel
        </Button>
        <Button variant="ghost">Run in background</Button>
      </div>
      {SKELETONS.map((rows, i) => (
        <div className={s.skeletonCard} key={i}>
          <Skeleton width={`${rows[0]}%`} height={12} />
          <Skeleton width={`${rows[1]}%`} height={12} />
          <div className={s.skelGap} />
          <Skeleton width={`${rows[2]}%`} height={12} />
          <Skeleton width={`${rows[3]}%`} height={12} />
        </div>
      ))}
    </>
  );
}
