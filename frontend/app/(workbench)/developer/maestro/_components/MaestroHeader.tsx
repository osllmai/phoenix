'use client';

import { PageHeader } from '@/app/components/ui';

import { PLAN_PATTERNS } from './sampleData';
import s from '../page.module.css';

export default function MaestroHeader({
  goal,
  onGoal,
  onRun,
}: {
  goal: string;
  onGoal: (v: string) => void;
  onRun: () => void;
}) {
  return (
    <PageHeader
      title="Maestro"
      actions={
        <>
          <button className={s.run} type="button" onClick={onRun}>
            ▶ Run
          </button>
          <button className={s.iconbtn} type="button" title="Pause">
            ⏸
          </button>
          <button className={s.iconbtn} type="button">
            ＋ agent
          </button>
        </>
      }
    >
      <input
        className={s.goalbox}
        value={goal}
        onChange={(e) => onGoal(e.target.value)}
        placeholder="Describe a goal for the orchestra…"
      />
      <select className={s.patternSel} title="Plan pattern" defaultValue={PLAN_PATTERNS[0]}>
        {PLAN_PATTERNS.map((p) => (
          <option key={p}>{p}</option>
        ))}
      </select>
    </PageHeader>
  );
}
