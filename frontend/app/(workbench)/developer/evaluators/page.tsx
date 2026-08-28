'use client';

import { useState } from 'react';

import {
  Button,
  EmptyState,
  ErrorState,
  PageHeader,
} from '@/app/components/ui';
import SectionTabs from '@/app/components/SectionTabs';
import { DEV_TABS } from '@/app/components/sectionTabs.config';

import EvaluatorCard from './_components/EvaluatorCard';
import EvaluateSheet from './_components/EvaluateSheet';
import LoadingScorecard from './_components/LoadingScorecard';
import Scorecard from './_components/Scorecard';
import { SAMPLE_EVALUATORS, SAMPLE_SCORECARD, type EvalState } from './_components/data';
import s from './page.module.css';
import { MockStateSwitcher } from '@/app/components/dev/MockStateSwitcher';

const STATES: EvalState[] = ['success', 'empty', 'first-run', 'loading', 'error', 'denied'];

export default function EvaluatorsPage() {
  const [state, setState] = useState<EvalState>('success');
  const [evaluators, setEvaluators] = useState(SAMPLE_EVALUATORS);
  const [sheetOpen, setSheetOpen] = useState(false);

  const toggle = (id: string) =>
    setEvaluators((prev) =>
      prev.map((e) => (e.id === id ? { ...e, enabled: !e.enabled } : e)),
    );

  return (
    <>
      <SectionTabs items={DEV_TABS} />

      <MockStateSwitcher
        states={STATES}
        value={state}
        onChange={setState}
        className={s.devSwitcher}
        activeClassName={s.devSwitchOn}
      />

      <PageHeader
        title="Evaluators"
        actions={
          <>
            <Button variant="ghost">🧩 Manage in Extensions</Button>
            <Button onClick={() => setSheetOpen(true)}>▶ Evaluate now</Button>
            <Button variant="ghost">＋ Add evaluator</Button>
          </>
        }
      >
        <span className={s.headSub}>Score performer output · quality gates &amp; Panel judge</span>
      </PageHeader>

      <div className={s.jobbar}>
        <span className={s.dot} /> Eval containers online
        <span className={s.qpill}>2 evaluators · judge → local gateway</span>
        <span className={s.grow} />
        <span>Judge models run on-device via the gateway · egress-locked like any performer</span>
      </div>

      <div className={s.body}>{renderState(state, evaluators, toggle)}</div>

      {sheetOpen && <EvaluateSheet onClose={() => setSheetOpen(false)} />}
    </>
  );
}

function renderState(
  state: EvalState,
  evaluators: typeof SAMPLE_EVALUATORS,
  toggle: (id: string) => void,
) {
  if (state === 'empty') {
    return (
      <EmptyState
        icon="📭"
        title="No evaluators installed"
        description="Evaluators are opt-in extensions. Install one to start scoring performer output and to wire quality gates into Flows."
        actions={
          <>
            <Button>🧩 Browse marketplace</Button>
            <Button variant="ghost">Learn about evaluation</Button>
          </>
        }
      />
    );
  }

  if (state === 'first-run') {
    return (
      <EmptyState
        icon="⚖️"
        title="Install an evaluator to start scoring"
        description={
          <>
            Add <strong>indoxJudge</strong> (first-party safety + RAG eval) or{' '}
            <strong>Ragas</strong> (Apache-2.0 RAG metrics). Each points its judge model at the
            local gateway.
          </>
        }
        actions={
          <>
            <Button>＋ Install indoxJudge</Button>
            <Button variant="ghost">＋ Install Ragas</Button>
          </>
        }
      />
    );
  }

  if (state === 'loading') return <LoadingScorecard />;

  if (state === 'error') {
    return (
      <ErrorState
        title="Evaluation run failed"
        heading="indoxJudge — run #1285 errored"
        message="The judge model returned no parseable score. The eval container may have lost its gateway connection, or the judge model timed out scoring a long candidate."
        actions={
          <>
            <Button>Retry evaluation</Button>
            <Button variant="ghost">View container logs</Button>
          </>
        }
        sub="The performer's output is preserved — only the scoring step failed."
      />
    );
  }

  if (state === 'denied') {
    return (
      <ErrorState
        icon="🚫"
        variant="warning"
        title="Cloud judge needs a key"
        heading="IndoxHub account required"
        message={
          <>
            This evaluator&rsquo;s judge model is set to a cloud model (<code>gpt-4o</code> via IndoxHub).
            Cloud judges leave the device and require an IndoxHub key or account. Add one in
            Settings, or switch the judge back to a local gateway model.
          </>
        }
        actions={
          <>
            <Button>Add IndoxHub key</Button>
            <Button variant="ghost">Use local judge instead</Button>
          </>
        }
        sub="Local judge models run fully offline — no key needed."
      />
    );
  }

  return (
    <div className={s.wrap}>
      <section>
        <div className={s.sechead}>
          <h2>Installed evaluators</h2>
          <span className={s.hint}>opt-in extensions · point their judge model at the gateway</span>
        </div>
        {evaluators.map((e) => (
          <EvaluatorCard key={e.id} evaluator={e} onToggle={toggle} />
        ))}
      </section>

      <section>
        <div className={s.sechead}>
          <h2>Latest scorecard</h2>
          <span className={s.hint}>most recent evaluated run</span>
        </div>
        <Scorecard data={SAMPLE_SCORECARD} />
      </section>
    </div>
  );
}
