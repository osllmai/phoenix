'use client';

import { useState } from 'react';

import { Button, ErrorState, PageHeader } from '@/app/components/ui';
import { MockStateSwitcher } from '@/app/components/dev/MockStateSwitcher';
import SectionTabs from '@/app/components/SectionTabs';
import { DEV_TABS } from '@/app/components/sectionTabs.config';

import EmptyView from './_components/EmptyView';
import { DeniedView, FirstRunView } from './_components/HeroViews';
import LoadingView from './_components/LoadingView';
import SuccessView from './_components/SuccessView';
import { DEV_STATES, GATEWAY, SERVER, type DevState } from './_components/sampleData';
import s from './page.module.css';

function StatusPill({ state }: { state: DevState }) {
  if (state === 'first-run') {
    return (
      <span className={`${s.pill} ${s.stopped}`}>
        <span className={s.dot} />
        Stopped
      </span>
    );
  }
  if (state === 'loading') {
    return (
      <span className={`${s.pill} ${s.busy}`}>
        <span className={s.dot} />
        Starting…
      </span>
    );
  }
  if (state === 'error') {
    return (
      <span className={`${s.pill} ${s.errorPill}`}>
        <span className={s.dot} />
        Failed to start
      </span>
    );
  }
  return (
    <span className={`${s.pill} ${s.running}`}>
      <span className={s.dot} />
      Running · <span className={s.addr}>{SERVER.baseUrl}</span>
    </span>
  );
}

function HeaderActions({ state, onState }: { state: DevState; onState: (s: DevState) => void }) {
  if (state === 'first-run') return <Button onClick={() => onState('loading')}>Start server</Button>;
  if (state === 'error') return <Button onClick={() => onState('loading')}>Retry</Button>;
  if (state === 'loading') {
    return (
      <button className={s.btnStop} disabled style={{ opacity: 0.5, cursor: 'not-allowed' }}>
        Stop server
      </button>
    );
  }
  return (
    <>
      {state === 'success' && (
        <>
          <button className={s.btnSm} type="button">
            Copy base URL
          </button>
          <Button variant="ghost" onClick={() => onState('loading')}>
            Restart
          </Button>
        </>
      )}
      <button className={s.btnStop} type="button" onClick={() => onState('first-run')}>
        Stop server
      </button>
    </>
  );
}

export default function DeveloperPage() {
  const [state, setState] = useState<DevState>('success');

  return (
    <>
      <SectionTabs items={DEV_TABS} />

      <MockStateSwitcher
        states={DEV_STATES}
        value={state}
        onChange={setState}
        className={s.switcher}
        activeClassName={s.switchOn}
      />

      <PageHeader title="Developer · Server" actions={<HeaderActions state={state} onState={setState} />}>
        <StatusPill state={state} />
      </PageHeader>

      {state === 'success' && <SuccessView />}
      {state === 'empty' && <EmptyView />}
      {state === 'loading' && <LoadingView />}
      {state === 'first-run' && <FirstRunView onStart={() => setState('loading')} />}
      {state === 'denied' && <DeniedView />}
      {state === 'error' && (
        <ErrorState
          title="Could not start the server"
          heading={`Port ${GATEWAY.port} is already in use (EADDRINUSE)`}
          message={
            <>
              Another process is bound to <span className={s.inlineCode}>{`${GATEWAY.bind}:${GATEWAY.port}`}</span>, so the
              gateway can&apos;t open its socket. Free the port or pick a different one, then retry.
            </>
          }
          actions={
            <>
              <Button onClick={() => setState('loading')}>Retry</Button>
              <Button variant="ghost">Change port…</Button>
            </>
          }
          sub="The engine and your models are unaffected — only the HTTP gateway failed to bind."
        />
      )}
    </>
  );
}
