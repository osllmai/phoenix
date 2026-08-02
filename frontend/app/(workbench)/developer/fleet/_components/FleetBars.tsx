'use client';

import Link from 'next/link';

import { PROMPT_PRESETS, RECENT_PROMPTS } from './sampleData';
import s from '../page.module.css';

export function ChipBar() {
  return (
    <div className={s.chipbar}>
      <span className={s.chip}>
        <span className={s.dot} /> on-device · gateway ●
      </span>
      <span className={`${s.chip} ${s.sandbox}`}>🛡 sandboxed · local</span>
      <span className={s.chip}>🐳 egress-locked · 1 worktree + container / agent</span>
      <span className={s.grow} />
      <span>
        Same prompt, isolated worktrees · pick &amp; merge the winner · agents from{' '}
        <Link href="/extensions" className={s.link}>
          Extensions
        </Link>
      </span>
    </div>
  );
}

export function PresetBar({ onPick }: { onPick: (prompt: string) => void }) {
  return (
    <div className={s.presetbar}>
      <span className={s.presetLbl}>Presets</span>
      {PROMPT_PRESETS.map((p) => (
        <button key={p} className={s.preset} type="button" onClick={() => onPick(p)}>
          {p}
        </button>
      ))}
      <span className={`${s.presetLbl} ${s.presetGap}`}>Recent</span>
      {RECENT_PROMPTS.map((p) => (
        <button
          key={p}
          className={s.preset}
          type="button"
          onClick={() => onPick(p.replace('↺ ', ''))}
        >
          {p}
        </button>
      ))}
    </div>
  );
}
