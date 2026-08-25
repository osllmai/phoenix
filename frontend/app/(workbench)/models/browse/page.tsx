'use client';

import { useState } from 'react';
import Link from 'next/link';

import { Button, EmptyState, ErrorState, PageHeader } from '@/app/components/ui';
import { MockStateSwitcher } from '@/app/components/dev/MockStateSwitcher';
import SectionTabs from '@/app/components/SectionTabs';
import { MODELS_TABS } from '@/app/components/sectionTabs.config';

import Controls from './_components/Controls';
import SuccessView from './_components/SuccessView';
import { DeniedView, FirstRunView, LoadingView } from './_components/StateViews';
import { BROWSE_STATES, type BrowseState } from './_components/sampleData';
import s from './page.module.css';

const SEARCH: Record<BrowseState, string> = {
  success: 'llama 3.1 8b instruct GGUF',
  empty: 'dolphin-2.6-mistral-24b GGUF',
  'first-run': '',
  loading: 'qwen 7b instruct',
  error: 'llama 8b',
  denied: 'meta-llama/Llama-3.1-8B-Instruct',
};

function StatusPill({ state }: { state: BrowseState }) {
  if (state === 'success') {
    return (
      <span className={s.hfStatus}>
        <span className={`${s.statusDot} ${s.dotOk}`} /> Hub reachable · token set
      </span>
    );
  }
  const map: Record<string, [string, string]> = {
    loading: [s.dotWarn, 'Searching…'],
    error: [s.dotErr, 'Offline'],
    denied: [s.dotWarn, 'No token set'],
  };
  const [dot, label] = map[state] ?? [s.dotOk, 'Hub reachable'];
  return (
    <span className={s.hfStatus}>
      <span className={`${s.statusDot} ${dot}`} /> {label}
    </span>
  );
}

export default function ModelsBrowsePage() {
  const [state, setState] = useState<BrowseState>('success');

  return (
    <>
      <MockStateSwitcher
        states={BROWSE_STATES}
        value={state}
        onChange={setState}
        className={s.switcher}
        activeClassName={s.switchOn}
      />

      <SectionTabs items={MODELS_TABS} variant="tab" aria-label="Models sections" />

      <div className={s.advisory}>
        ☁ Browsing &amp; downloading runs <strong>off-device</strong> (needs network + optional HF
        token). A downloaded <code>.gguf</code> still runs locally once you load it.
      </div>

      <PageHeader title="Hugging Face">
        <StatusPill state={state} />
      </PageHeader>

      {state !== 'denied' && <Controls query={SEARCH[state]} />}

      {state === 'success' && <SuccessView />}
      {state === 'first-run' && <FirstRunView />}
      {state === 'loading' && <LoadingView />}
      {state === 'denied' && <DeniedView />}
      {state === 'empty' && (
        <EmptyState
          icon="🔍"
          title="No results"
          description={`No GGUF models match "${SEARCH.empty}" at this size. Try a broader query, a different size, or turn off the GGUF filter.`}
          actions={
            <Button variant="ghost" onClick={() => setState('success')}>
              Clear filters
            </Button>
          }
        />
      )}
      {state === 'error' && (
        <ErrorState
          icon="📡"
          title="Hugging Face unreachable"
          heading="Could not reach the Hub"
          message={
            <>
              Could not reach <code>huggingface.co/api/models</code>. Check your connection —
              already-downloaded models stay available under the{' '}
              <Link href="/models">Local</Link> tab.
            </>
          }
          actions={
            <>
              <Button onClick={() => setState('loading')}>Retry</Button>
              <Button variant="ghost" onClick={() => setState('success')}>
                Work offline
              </Button>
            </>
          }
        />
      )}
    </>
  );
}
