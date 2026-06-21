import { Button, CenterState, ErrorState } from '@/app/components/ui';
import { firstRunFeatures } from './data';
import s from '../page.module.css';

export function FirstRunView() {
  return (
    <CenterState
      icon="🔥"
      title="Your on-device LLM studio"
      description="No data leaves your machine. Get started in two steps: download a model, then add a document or start a chat."
      sub="Models & chats stay on-device · the backend handles document conversion jobs."
    >
      <div className={s.tips} style={{ display: 'flex', gap: 'var(--sp-2)', justifyContent: 'center' }}>
        <Button>⬇ Download a model</Button>
        <Button variant="ghost">＋ Add a document</Button>
      </div>
      <div className={s.featCards}>
        {firstRunFeatures.map((f) => (
          <div className={s.tip} key={f.title}>
            <div className={s.tipIco}>{f.icon}</div>
            <div className={s.tipT}>{f.title}</div>
            <div className={s.tipS}>{f.sub}</div>
          </div>
        ))}
      </div>
    </CenterState>
  );
}

export function ErrorView({ onRetry }: { onRetry?: () => void }) {
  return (
    <ErrorState
      title="Services offline"
      heading="Can't reach the Phoenix backend"
      message="The local server and document worker aren't responding. Inference still works on-device, but the dashboard, server API, and document jobs need the backend running."
      actions={
        <>
          <Button onClick={onRetry}>Retry connection</Button>
          <Button variant="ghost">Open logs</Button>
        </>
      }
      sub="Start the stack, then retry."
    />
  );
}

export function DeniedView() {
  return (
    <ErrorState
      variant="warning"
      icon="🚫"
      title="This area is restricted"
      heading="Overview is locked for this profile"
      message="This Phoenix profile doesn't have access to the overview dashboard, server controls, or usage metrics. An administrator can grant access in profile settings."
      actions={
        <>
          <Button>Switch profile</Button>
          <Button variant="ghost">Request access</Button>
        </>
      }
      sub="Local-only · no telemetry ever leaves your machine."
    />
  );
}
