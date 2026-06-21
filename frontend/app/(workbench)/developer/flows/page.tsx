'use client';

import { useState } from 'react';

import { PageHeader } from '@/app/components/ui';
import SectionTabs from '@/app/components/SectionTabs';
import { DEV_TABS } from '@/app/components/sectionTabs.config';

import FlowCanvas from './_components/FlowCanvas';
import Inspector from './_components/Inspector';
import Palette from './_components/Palette';
import RunSheet from './_components/RunSheet';
import SuccessToolbar from './_components/SuccessToolbar';
import { LoadingPane, ErrorPane } from './_components/RunPanes';
import { DeniedPane, EmptyPane, FirstRunPane } from './_components/StatePanes';
import {
  SAMPLE_BRANCH_LABELS,
  SAMPLE_NODES,
  SAMPLE_WIRES,
} from './_components/sampleData';
import s from './page.module.css';

type ViewState = 'success' | 'empty' | 'first-run' | 'loading' | 'error' | 'denied';

const STATES: ViewState[] = ['success', 'empty', 'first-run', 'loading', 'error', 'denied'];

export default function FlowsPage() {
  const [view, setView] = useState<ViewState>('success');
  const [selectedId, setSelectedId] = useState<string | null>('draft');
  const [sheetOpen, setSheetOpen] = useState(false);

  return (
    <main className={s.page}>
      <SectionTabs items={DEV_TABS} />

      <PageHeader title="Flows">
        <span className={s.headerGrow} />
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

      <div className={s.flowpane}>
        {view === 'success' && (
          <>
            <SuccessToolbar onRun={() => setSheetOpen(true)} />
            <div className={s.builder}>
              <Palette />
              <FlowCanvas
                nodes={SAMPLE_NODES}
                wires={SAMPLE_WIRES}
                labels={SAMPLE_BRANCH_LABELS}
                selectedId={selectedId}
                onSelect={setSelectedId}
              />
              <Inspector />
            </div>
          </>
        )}

        {view === 'loading' && <LoadingPane />}
        {view === 'error' && <ErrorPane onRetry={() => setView('success')} />}
        {view === 'empty' && <EmptyPane onNew={() => setView('first-run')} />}
        {view === 'first-run' && <FirstRunPane onBlank={() => setView('success')} />}
        {view === 'denied' && <DeniedPane />}
      </div>

      {sheetOpen && <RunSheet onClose={() => setSheetOpen(false)} />}
    </main>
  );
}
