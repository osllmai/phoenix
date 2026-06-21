import { Skeleton } from '@/app/components/ui';
import s from '../page.module.css';

export default function LoadingPane() {
  return (
    <div className={s.loadingBrowse}>
      <div className={s.loadingHd}>Loading marketplace…</div>
      {[0.5, 0.35, 0.45].map((w, i) => (
        <div key={i} className={s.skelRow}>
          <Skeleton width={40} height={40} radius="var(--r-md)" />
          <div className={s.skelLines}>
            <Skeleton width={`${w * 100}%`} />
            <Skeleton width={`${(w + 0.2) * 100}%`} />
          </div>
          <Skeleton width={64} height={30} radius="var(--r-md)" />
        </div>
      ))}
    </div>
  );
}
