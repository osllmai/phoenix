'use client';

import { useState } from 'react';

import SectionTabs from '@/app/components/SectionTabs';
import { DEV_TABS } from '@/app/components/sectionTabs.config';

import Conductor from './_components/Conductor';
import MaestroHeader from './_components/MaestroHeader';
import TerminalGrid from './_components/TerminalGrid';
import { ChipBar, PresetBar } from './_components/MaestroBars';
import {
  DeniedPane,
  EmptyPane,
  ErrorPane,
  FirstRunPane,
  LoadingPane,
} from './_components/StatePanes';
import { SAMPLE_GOAL, type MaestroState } from './_components/sampleData';
import s from './page.module.css';

const STATES: MaestroState[] = ['success', 'empty', 'first-run', 'loading', 'error', 'denied'];

export default function MaestroPage() {
  const [state, setState] = useState<MaestroState>('success');
  const [goal, setGoal] = useState(SAMPLE_GOAL);

  return (
    <main className={s.page}>
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

      <SectionTabs items={DEV_TABS} />
      <MaestroHeader goal={goal} onGoal={setGoal} onRun={() => setState('loading')} />
      <ChipBar />
      <PresetBar onPick={setGoal} />

      <div className={s.body}>
        {state === 'success' && (
          <div className={s.split}>
            <Conductor />
            <TerminalGrid />
          </div>
        )}
        {state === 'empty' && <EmptyPane />}
        {state === 'first-run' && <FirstRunPane onRun={() => setState('loading')} />}
        {state === 'loading' && <LoadingPane />}
        {state === 'error' && <ErrorPane />}
        {state === 'denied' && <DeniedPane />}
      </div>
    </main>
  );
}
