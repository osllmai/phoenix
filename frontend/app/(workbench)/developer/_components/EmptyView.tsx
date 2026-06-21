import { Button, CenterState } from '@/app/components/ui';

import { EndpointsCard } from './cards';
import s from '../page.module.css';
import { ENDPOINTS } from './sampleData';

export default function EmptyView() {
  return (
    <div className={s.body}>
      <EndpointsCard endpoints={ENDPOINTS.filter((e) => e.tag !== 'OpenAI' || e.url.includes('chat'))} />
      <div className={s.card}>
        <div className={s.cardHead}>
          <h3>Request log</h3>
          <span className={s.live}>
            <span className={s.liveDot} />
            live
          </span>
        </div>
        <div className={s.cardBody}>
          <CenterState
            icon="📡"
            title="Waiting for the first request"
            description="The server is up and listening, but no client has called it yet. Send a request to /v1/chat/completions or /v1/messages and it will appear here in real time."
          >
            <div style={{ display: 'flex', gap: 'var(--sp-2)', justifyContent: 'center' }}>
              <Button variant="ghost">Copy curl example</Button>
              <Button>View quick start</Button>
            </div>
          </CenterState>
        </div>
      </div>
    </div>
  );
}
