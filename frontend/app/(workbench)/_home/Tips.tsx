import { Card, CardHead } from '@/app/components/ui';
import { tips } from './data';
import s from '../page.module.css';

export function Tips() {
  return (
    <Card>
      <CardHead title="Tips & getting started" />
      <div className={s.tips}>
        {tips.map((tip) => (
          <div className={s.tip} key={tip.title}>
            <div className={s.tipIco}>{tip.icon}</div>
            <div className={s.tipT}>{tip.title}</div>
            <div className={s.tipS}>{tip.sub}</div>
          </div>
        ))}
      </div>
    </Card>
  );
}
