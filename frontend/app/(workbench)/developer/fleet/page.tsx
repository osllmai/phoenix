'use client';

import { useState } from 'react';

import SectionTabs from '@/app/components/SectionTabs';
import { DEV_TABS } from '@/app/components/sectionTabs.config';

import { ChipBar, PresetBar } from './_components/FleetBars';
import FleetHeader from './_components/FleetHeader';
import FleetWorkspace from './_components/FleetWorkspace';
import {
  DeniedPane,
  EmptyPane,
  ErrorPane,
  FirstRunPane,
  LoadingPane,
} from './_components/StatePanes';
import { SAMPLE_PROMPT, type FleetState } from './_components/sampleData';
import s from './page.module.css';

const STATES: FleetState[] = ['success', 'empty', 'first-run', 'loading', 'error', 'denied'];
const SHOW_SWITCHER = process.env.NODE_ENV !== 'production';

export default function FleetPage() {
  const [state, setState] = useState<FleetState>('success');
  const [prompt, setPrompt] = useState(SAMPLE_PROMPT);

  return (
    <main className={s.page}>
      {SHOW_SWITCHER && (
        <div className={s.switcher}>
          {STATES.map((st) => (
            <button
              key={st}
              type="button"
              className={state === st ? s.switchOn : ''}
              onClick={() => setState(st)}
            >
              {st}
            </button>
          ))}
        </div>
      )}

      <SectionTabs items={DEV_TABS} />
      <FleetHeader prompt={prompt} onPrompt={setPrompt} onRun={() => setState('loading')} />
      <ChipBar />
      <PresetBar onPick={setPrompt} />

      <div className={s.body}>
        {state === 'success' && <FleetWorkspace />}
        {state === 'empty' && <EmptyPane onRun={() => setState('loading')} />}
        {state === 'first-run' && <FirstRunPane onRun={() => setState('loading')} />}
        {state === 'loading' && <LoadingPane />}
        {state === 'error' && <ErrorPane />}
        {state === 'denied' && <DeniedPane />}
      </div>
    </main>
  );
}
