'use client';

import { PageHeader } from '@/app/components/ui';

import { FANOUT_OPTIONS } from './sampleData';
import s from '../page.module.css';

export default function FleetHeader({
  prompt,
  onPrompt,
  onRun,
}: {
  prompt: string;
  onPrompt: (v: string) => void;
  onRun: () => void;
}) {
  return (
    <PageHeader
      title="Fleet"
      actions={
        <>
          <button className={s.run} type="button" onClick={onRun}>
            ▶ Fan out
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
        value={prompt}
        onChange={(e) => onPrompt(e.target.value)}
        placeholder="One prompt → fan out across agents…"
      />
      <select className={s.patternSel} title="Agents to fan out across" defaultValue={FANOUT_OPTIONS[0]}>
        {FANOUT_OPTIONS.map((o) => (
          <option key={o}>{o}</option>
        ))}
      </select>
      <label
        className={s.toggle}
        title="Stop the race as soon as one agent passes — or run them all to completion"
      >
        <input type="checkbox" defaultChecked />
        <span>Race · stop on first green</span>
      </label>
    </PageHeader>
  );
}
