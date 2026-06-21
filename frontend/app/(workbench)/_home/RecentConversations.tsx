import { Card, CardHead, CardLink } from '@/app/components/ui';
import { conversationTotal, recentConversations } from './data';
import s from '../page.module.css';

export function RecentConversations() {
  return (
    <Card>
      <CardHead
        title="Recent conversations"
        action={<CardLink>View all ({conversationTotal})</CardLink>}
      />
      {recentConversations.map((conv) => (
        <button className={s.conv} type="button" key={conv.title} title="Resume this chat">
          <span className={s.cIco}>{conv.icon}</span>
          <div className={s.cBody}>
            <div className={s.cTitle}>{conv.title}</div>
            <div className={s.cMeta}>{conv.meta}</div>
          </div>
          <span className={s.cTime}>{conv.time}</span>
          <span className={s.cGo}>›</span>
        </button>
      ))}
    </Card>
  );
}
