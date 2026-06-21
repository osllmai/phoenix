import { Card, CardHead } from '@/app/components/ui';
import { quickActions } from './data';
import s from '../page.module.css';

export function QuickActions({ subs }: { subs?: string[] }) {
  return (
    <Card>
      <CardHead title="Quick actions" />
      <div className={s.qaGrid}>
        {quickActions.map((action, i) => (
          <button className={s.qa} type="button" key={action.title}>
            <span className={s.qaIco}>{action.icon}</span>
            <span className={s.qaT}>{action.title}</span>
            <span className={s.qaS}>{subs?.[i] ?? action.sub}</span>
          </button>
        ))}
      </div>
    </Card>
  );
}
