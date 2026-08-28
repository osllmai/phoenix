'use client';

import { useState } from 'react';

import { MockStateSwitcher } from '@/app/components/dev/MockStateSwitcher';
import { Button, CenterState, EmptyState, ErrorState } from '@/app/components/ui';

import LoadingView from './_components/LoadingView';
import SearchHeader, { type Scopes } from './_components/SearchHeader';
import SuccessView from './_components/SuccessView';
import { EXAMPLE_QUERIES, SAMPLE_QUERY, type DsState } from './_components/sampleData';
import s from './page.module.css';

const STATES: DsState[] = ['success', 'empty', 'first-run', 'loading', 'error', 'denied'];

export default function DeepSearchPage() {
  const [state, setState] = useState<DsState>('success');
  const [query, setQuery] = useState(SAMPLE_QUERY);
  const [scopes, setScopes] = useState<Scopes>({ web: true, local: true });
  const [depth, setDepth] = useState<'Quick' | 'Standard' | 'Deep'>('Standard');

  const toggleScope = (key: keyof Scopes) =>
    setScopes((prev) => ({ ...prev, [key]: !prev[key] }));

  return (
    <>
      <MockStateSwitcher
        states={STATES}
        value={state}
        onChange={setState}
        className={s.switcher}
        activeClassName={s.switchOn}
      />

      <SearchHeader
        query={query}
        onQuery={setQuery}
        onRun={() => setState('loading')}
        scopes={scopes}
        onToggleScope={toggleScope}
        depth={depth}
        onDepth={setDepth}
      />

      <div className={s.body}>
        {state === 'success' && <SuccessView />}
        {state === 'loading' && <LoadingView onCancel={() => setState('first-run')} />}

        {state === 'empty' && (
          <EmptyState
            icon="🔎"
            title="No results for this query"
            description="No relevant web pages or local documents matched. Try broadening the question, widening the scope, or increasing the depth."
            actions={
              <>
                <div className={s.echo}>
                  &ldquo;Token-tree rejection sampling on TPUs, Q3 2025 only&rdquo;
                </div>
                <Button onClick={() => setQuery('')}>Broaden query</Button>
                <Button variant="ghost" onClick={() => setScopes({ web: true, local: true })}>
                  Enable all scopes
                </Button>
              </>
            }
          />
        )}

        {state === 'first-run' && (
          <CenterState
            icon="🔭"
            title="Enter your first research question"
            description="Phoenix searches the web and your local documents, reads and ranks the results, then synthesizes a cited answer — synthesis runs entirely on your device."
          >
            <div className={s.exampleChips}>
              {EXAMPLE_QUERIES.map((q) => (
                <button
                  className={s.exampleChip}
                  type="button"
                  key={q}
                  onClick={() => {
                    setQuery(q);
                    setState('loading');
                  }}
                >
                  {q}
                </button>
              ))}
            </div>
          </CenterState>
        )}

        {state === 'error' && (
          <ErrorState
            title=" "
            heading="Research job failed"
            message="Worker timeout after 120s while fetching the web. The Celery worker may be under heavy load, or the network / search backend is unreachable."
            actions={
              <>
                <Button onClick={() => setState('loading')}>Retry</Button>
                <Button variant="ghost">View logs</Button>
              </>
            }
            sub={<span className={s.mono}>Job #a3f91b · status: failed · 2026-06-12 09:41 UTC</span>}
          />
        )}

        {state === 'denied' && (
          <ErrorState
            icon="🔒"
            variant="warning"
            title=" "
            heading="Web search disabled"
            message="Web research is turned off by policy. Enable web search in Settings, or restrict the scope to your local documents to continue."
            actions={
              <>
                <Button>Open Settings</Button>
                <Button variant="ghost" onClick={() => setScopes({ web: false, local: true })}>
                  Search local docs only
                </Button>
              </>
            }
            sub="On-device chat (💬) and local-document search still work — only outbound web research is restricted."
          />
        )}
      </div>
    </>
  );
}
