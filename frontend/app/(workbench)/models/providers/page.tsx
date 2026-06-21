'use client';

import { useState } from 'react';

import { Button, PageHeader } from '@/app/components/ui';
import SectionTabs from '@/app/components/SectionTabs';
import { MODELS_TABS } from '@/app/components/sectionTabs.config';

import AddDialog from './_components/AddDialog';
import { EmptyView, FirstRunView } from './_components/HeroViews';
import {
  DeniedView,
  ErrorView,
  LoadingView,
  SuccessView,
} from './_components/StateViews';
import { PROVIDERS_STATES, type ProvidersState } from './_components/sampleData';
import s from './page.module.css';

function HeaderActions({
  state,
  onAdd,
}: {
  state: ProvidersState;
  onAdd: () => void;
}) {
  if (state === 'first-run' || state === 'loading') return null;
  return (
    <>
      {(state === 'success' || state === 'error') && <Button variant="ghost">Test all</Button>}
      <Button onClick={onAdd}>＋ Add provider</Button>
    </>
  );
}

export default function ProvidersPage() {
  const [state, setState] = useState<ProvidersState>('success');
  const showDialog = state === 'add';
  const closeDialog = () => setState('success');

  return (
    <>
      <div className={s.switcher}>
        {PROVIDERS_STATES.map((st) => (
          <button
            className={state === st ? s.switchOn : ''}
            type="button"
            key={st}
            onClick={() => setState(st)}
          >
            {st}
          </button>
        ))}
      </div>

      <SectionTabs items={MODELS_TABS} variant="tab" aria-label="Models sections" />

      <PageHeader
        title="Providers & API Keys"
        actions={<HeaderActions state={state} onAdd={() => setState('add')} />}
      />

      {(state === 'success' || state === 'add') && <SuccessView />}
      {state === 'loading' && <LoadingView />}
      {state === 'error' && <ErrorView onRetry={() => setState('loading')} />}
      {state === 'denied' && <DeniedView onUpdate={() => setState('add')} />}
      {state === 'empty' && <EmptyView onConnect={() => setState('add')} />}
      {state === 'first-run' && <FirstRunView onConnect={() => setState('add')} />}

      {showDialog && <AddDialog onClose={closeDialog} />}
    </>
  );
}
