import { Skeleton } from '@/app/components/ui';

import s from '../page.module.css';
import { BOOT_LOG } from './sampleData';

export default function LoadingView() {
  return (
    <div className={s.body}>
      <div className={s.card}>
        <div className={s.cardHead}>
          <h3>Status &amp; usage</h3>
        </div>
        <div className={s.cardBody}>
          <div className={s.statGrid}>
            {[50, 60, 40, 55, 65].map((w, i) => (
              <div className={s.skelStat} key={i}>
                <Skeleton width="50%" height={12} />
                <Skeleton width={`${w}%`} height={18} />
              </div>
            ))}
          </div>
        </div>
      </div>
      <div className={s.card}>
        <div className={s.cardHead}>
          <h3>Boot log</h3>
        </div>
        <div className={`${s.cardBody} ${s.bootBody}`}>
          {BOOT_LOG.map((line) => (
            <div className={s.boot} key={line}>
              {line}
            </div>
          ))}
          <Skeleton width="48%" height={12} />
          <Skeleton width="60%" height={12} />
        </div>
      </div>
    </div>
  );
}
