'use client';

import { useState } from 'react';

import { PageHeader } from '@/app/components/ui';
import SectionTabs from '@/app/components/SectionTabs';
import { MODELS_TABS } from '@/app/components/sectionTabs.config';
import { CREDITS, FILTER_PILLS, SORT_OPTIONS } from './_components/sampleData';
import SuccessView from './_components/SuccessView';
import { EmptyPane, FirstRunPane, LoadingPane, ErrorPane, DeniedPane } from './_components/StatePanes';
import s from './page.module.css';

type ViewState = 'success' | 'empty' | 'first-run' | 'loading' | 'error' | 'denied';

const STATES: ViewState[] = ['success', 'empty', 'first-run', 'loading', 'error', 'denied'];

const CONN: Record<ViewState, { cls: string; dot: string; label: string }> = {
  success: { cls: s.connOk, dot: s.dotOk, label: 'Connected' },
  empty: { cls: s.connOk, dot: s.dotOk, label: 'Connected' },
  'first-run': { cls: s.connOff, dot: s.dotOff, label: 'Not connected' },
  loading: { cls: s.connOff, dot: s.dotWait, label: 'Connecting…' },
  error: { cls: s.connErr, dot: s.dotErr, label: 'Gateway unreachable' },
  denied: { cls: s.connErr, dot: s.dotErr, label: '401 Unauthorized' },
};

export default function OnlineModelsPage() {
  const [view, setView] = useState<ViewState>('success');
  const [query, setQuery] = useState('');
  const [filter, setFilter] = useState('All');

  const conn = CONN[view];
  const showCredits = view === 'success' || view === 'empty';
  const showToolbar = view === 'success' || view === 'empty';

  return (
    <main className={s.page}>
      <SectionTabs items={MODELS_TABS} variant="tab" aria-label="Models sections" />

      <PageHeader title="Online · IndoxHub">
        <span className={s.headGrow} />
        {showCredits && (
          <span className={s.credits} title="IndoxHub account balance">
            Credits <b>{CREDITS.balance}</b>
            <span className={s.creditsBar}>
              <i style={{ width: `${CREDITS.percent}%` }} />
            </span>
          </span>
        )}
        <span className={`${s.connPill} ${conn.cls}`}>
          <span className={`${s.connDot} ${conn.dot}`} />
          {conn.label}
        </span>
        {view !== 'first-run' && (
          <button type="button" className={s.keyBtn}>
            {view === 'denied' ? 'Update key' : 'Manage keys'}
          </button>
        )}
        <div className={s.switcher}>
          {STATES.map((st) => (
            <button
              key={st}
              type="button"
              className={`${s.switch} ${view === st ? s.switchOn : ''}`}
              onClick={() => setView(st)}
            >
              {st}
            </button>
          ))}
        </div>
      </PageHeader>

      {showToolbar && (
        <div className={s.cloudNotice}>
          ☁ These models run <strong>in the cloud via IndoxHub</strong> — not on-device. Prompts
          leave your machine and bill against credits (or your own key with BYOK). Choose{' '}
          <strong>Local</strong> for fully private inference.
        </div>
      )}

      {showToolbar && (
        <div className={s.toolbar}>
          <input
            className={s.search}
            placeholder="Search models, e.g. claude, vision, 200k…"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
          />
          <div className={s.filters}>
            {FILTER_PILLS.map((f) => (
              <button
                key={f}
                type="button"
                className={`${s.fpill} ${filter === f ? s.fpillOn : ''}`}
                onClick={() => setFilter(f)}
              >
                {f}
              </button>
            ))}
          </div>
          <span className={s.headGrow} />
          <select className={s.sortSel} aria-label="Sort models">
            {SORT_OPTIONS.map((o) => (
              <option key={o}>{o}</option>
            ))}
          </select>
        </div>
      )}

      <div className={s.body}>
        {view === 'success' && <SuccessView query={query} />}
        {view === 'loading' && <LoadingPane />}
        {view === 'empty' && <EmptyPane onClear={() => setQuery('')} />}
        {view === 'first-run' && <FirstRunPane />}
        {view === 'error' && <ErrorPane onRetry={() => setView('success')} />}
        {view === 'denied' && <DeniedPane />}
      </div>
    </main>
  );
}
