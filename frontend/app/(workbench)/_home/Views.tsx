import { Card, Skeleton } from '@/app/components/ui';
import { Hero, HeroEmpty } from './Hero';
import { QuickActions } from './QuickActions';
import { RecentConversations } from './RecentConversations';
import { DocLibrary, Resources, ServerStatus } from './SidePanels';
import { Tips } from './Tips';
import s from '../page.module.css';

export function SuccessView() {
  return (
    <div className={s.canvas}>
      <div className={s.grid}>
        <div className={`${s.col7} ${s.stack}`}>
          <Hero />
          <QuickActions />
          <RecentConversations />
        </div>
        <div className={`${s.col5} ${s.stack}`}>
          <DocLibrary />
          <ServerStatus />
          <Resources />
        </div>
        <div className={s.col12}>
          <Tips />
        </div>
      </div>
    </div>
  );
}

export function EmptyView() {
  const subs = ['Needs a loaded model', 'Convert & index a file', 'No documents yet'];
  return (
    <div className={s.canvas}>
      <div className={s.grid}>
        <div className={`${s.col7} ${s.stack}`}>
          <HeroEmpty />
          <QuickActions subs={subs} />
        </div>
        <div className={`${s.col5} ${s.stack}`}>
          <Card className={s.emptySide}>
            <div className={s.emptyBig}>🗂️</div>
            <h2 className={s.emptyTitle}>Nothing here yet</h2>
            <p className={s.emptySub}>
              Your recent conversations, documents, and usage will appear here once you get going.
            </p>
          </Card>
        </div>
      </div>
    </div>
  );
}

export function LoadingView() {
  return (
    <div className={s.canvas}>
      <div className={s.grid}>
        <div className={`${s.col7} ${s.stack}`}>
          <div className={s.hero}>
            <Skeleton height={96} radius="var(--r-md)" />
          </div>
          <Card>
            <Skeleton width="30%" height={12} />
            <div className={s.qaGrid} style={{ marginTop: 'var(--sp-3)' }}>
              <Skeleton height={78} radius="var(--r-md)" />
              <Skeleton height={78} radius="var(--r-md)" />
              <Skeleton height={78} radius="var(--r-md)" />
            </div>
          </Card>
          <Card>
            <Skeleton width="40%" height={12} />
            <Skeleton height={14} />
            <Skeleton width="80%" height={14} />
            <Skeleton width="60%" height={14} />
          </Card>
        </div>
        <div className={`${s.col5} ${s.stack}`}>
          <Card>
            <Skeleton height={90} radius="var(--r-md)" />
          </Card>
          <Card>
            <Skeleton height={120} radius="var(--r-md)" />
          </Card>
          <Card>
            <Skeleton height={90} radius="var(--r-md)" />
          </Card>
        </div>
      </div>
    </div>
  );
}
