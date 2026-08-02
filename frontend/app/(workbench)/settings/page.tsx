'use client';

import { useState } from 'react';

import { PageHeader } from '@/app/components/ui';

import SettingsNav from './_components/SettingsNav';
import SuccessPanel from './_components/SuccessPanel';
import {
  DeniedPanel,
  EmptyPanel,
  ErrorPanel,
  FirstRunPanel,
  LoadingPanel,
} from './_components/StatePanels';
import type { SettingsState } from './sample';
import s from './page.module.css';

const STATES: SettingsState[] = ['success', 'empty', 'first-run', 'loading', 'error', 'denied'];

const STATE_SECTION: Record<Exclude<SettingsState, 'success' | 'first-run'>, string> = {
  empty: 'models',
  loading: 'appearance',
  error: 'models',
  denied: 'backend',
};

export default function SettingsPage() {
  const [state, setState] = useState<SettingsState>('success');
  const [section, setSection] = useState('general');

  return (
    <>
      <PageHeader
        title="Settings"
        actions={
          <div className={s.switcher}>
            {STATES.map((st) => (
              <button
                key={st}
                type="button"
                className={state === st ? s.on : ''}
                onClick={() => {
                  setState(st);
                  if (st !== 'success' && st !== 'first-run') setSection(STATE_SECTION[st]);
                }}
              >
                {st}
              </button>
            ))}
          </div>
        }
      />
      <Body state={state} section={section} onSection={setSection} />
    </>
  );
}

function Body({
  state,
  section,
  onSection,
}: {
  state: SettingsState;
  section: string;
  onSection: (id: string) => void;
}) {
  if (state === 'success') return <SuccessPanel />;
  if (state === 'first-run') return <FirstRunPanel />;

  return (
    <div className={s.shell}>
      <SettingsNav active={section} onSelect={onSection} searchable={false} />
      <div className={s.panel}>
        {state === 'loading' && <LoadingPanel />}
        {state === 'empty' && <EmptyPanel />}
        {state === 'error' && <ErrorPanel />}
        {state === 'denied' && <DeniedPanel />}
      </div>
    </div>
  );
}
