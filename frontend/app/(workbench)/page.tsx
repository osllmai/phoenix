'use client';

import { useState } from 'react';

import { MockStateSwitcher } from '@/app/components/dev/MockStateSwitcher';
import { PageHeader } from '@/app/components/ui';
import { HOME_STATES, type HomeState } from './_home/data';
import { EmptyView, LoadingView, SuccessView } from './_home/Views';
import { DeniedView, ErrorView, FirstRunView } from './_home/CenterViews';
import s from './page.module.css';

const TITLES: Record<HomeState, string> = {
  success: 'Welcome back',
  empty: 'Welcome back',
  'first-run': 'Welcome to Phoenix',
  loading: 'Welcome back',
  error: 'Welcome back',
  denied: 'Welcome back',
};

export default function Home() {
  const [state, setState] = useState<HomeState>('success');

  const refreshLabel =
    state === 'error' ? '↻ Retry' : state === 'loading' ? 'Loading overview…' : '↻ Refresh';
  const showRefresh = state === 'success' || state === 'empty' || state === 'error';

  return (
    <>
      <MockStateSwitcher
        states={HOME_STATES}
        value={state}
        onChange={setState}
        className={s.switcher}
        activeClassName={s.on}
      />

      <PageHeader title={TITLES[state]} actions={<HeaderActions state={state} label={refreshLabel} show={showRefresh} onRetry={() => setState('loading')} />}>
        {state === 'success' && (
          <div className={s.privacyChip}>
            <span className={s.privacyDot} />
            Everything runs on-device
          </div>
        )}
      </PageHeader>

      {state === 'success' && <SuccessView />}
      {state === 'empty' && <EmptyView />}
      {state === 'loading' && <LoadingView />}
      {state === 'first-run' && <FirstRunView />}
      {state === 'error' && <ErrorView onRetry={() => setState('success')} />}
      {state === 'denied' && <DeniedView />}
    </>
  );
}

function HeaderActions({
  state,
  label,
  show,
  onRetry,
}: {
  state: HomeState;
  label: string;
  show: boolean;
  onRetry: () => void;
}) {
  if (state === 'loading') return <span className={s.last}>{label}</span>;
  if (!show) return null;
  return (
    <>
      <button className={s.refreshbtn} type="button" onClick={onRetry}>
        {label}
      </button>
      {state === 'success' && <span className={s.last}>Updated 14:02:31</span>}
    </>
  );
}
