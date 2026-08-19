'use client';

import { useState } from 'react';

import { Button, CenterState, EmptyState, ErrorState, Skeleton } from '@/app/components/ui';

import { FIRST_RUN_ROSTER } from './sampleData';
import s from '../page.module.css';

export function EmptyPane({ onRun }: { onRun: () => void }) {
  return (
    <EmptyState
      icon="🐳"
      title="No fleet running"
      description="Type one prompt and fan it out across several coding agents. Each runs in its own isolated git worktree (egress-locked container), so they never step on each other — then you compare the diffs and merge the winner."
      actions={<Button onClick={onRun}>▶ Fan out a prompt</Button>}
    />
  );
}

export function FirstRunPane({ onRun }: { onRun: () => void }) {
  const [roster, setRoster] = useState(FIRST_RUN_ROSTER);
  const toggle = (name: string) =>
    setRoster((prev) => prev.map((a) => (a.name === name ? { ...a, on: !a.on } : a)));

  return (
    <CenterState
      icon="🏁"
      title="Start your first race"
      description="Pick the agents to compete on the same task. Tier-A agents stay fully on-device and offline; the gateway serves each one the local model."
      sub="Manage installed agents in Extensions."
    >
      <div className={s.picker}>
        {roster.map((a) => (
          <button
            key={a.name}
            type="button"
            className={`${s.agentcard} ${a.on ? s.agentOn : ''}`}
            onClick={() => toggle(a.name)}
          >
            <span className={`${s.tierBadge} ${a.cloud ? s.tierCloud : ''}`}>{a.tier}</span>
            {a.icon} {a.name}
          </button>
        ))}
      </div>
      <div className={s.btnrow}>
        <Button onClick={onRun}>Create 3 worktrees &amp; run</Button>
      </div>
    </CenterState>
  );
}

export function LoadingPane() {
  const rows = [
    [50, 80, 64],
    [42, 70, 55],
    [55, 64, 72],
    [48, 72, 60],
  ];
  return (
    <div className={s.gridpane}>
      <div className={s.loadingNote}>
        Spinning up worktrees &amp; containers…{' '}
        <span className={s.loadingMono}>pulling image · mounting worktree · wiring gateway</span>
      </div>
      <div className={s.skelGrid}>
        {rows.map((widths, i) => (
          <div key={i} className={s.skelTerm}>
            {widths.map((w, j) => (
              <Skeleton key={j} width={`${w}%`} height={j === 0 ? 12 : 10} />
            ))}
          </div>
        ))}
      </div>
    </div>
  );
}

export function ErrorPane() {
  return (
    <ErrorState
      title="A lane crashed"
      heading="codex · container out of memory"
      message="The codex worktree exceeded its sandbox memory limit and was stopped. Its worktree was reverted; the other lanes are unaffected."
      actions={
        <>
          <Button>↻ Retry codex</Button>
          <Button variant="ghost">Raise memory limit</Button>
          <Button variant="ghost">Drop this lane</Button>
        </>
      }
      sub="Other agents keep racing — you can still merge a winner without this lane."
    />
  );
}

export function DeniedPane() {
  return (
    <ErrorState
      icon="🚫"
      variant="warning"
      title="Agent can't join the race"
      heading="gemini-cli · Tier B — leaves the device"
      message="Gemini CLI routes to Google's cloud, so it can't run inside a Tier-A (offline, egress-locked) worktree. Add it only if you allow cloud egress for this fleet."
      actions={
        <>
          <Button>Allow cloud &amp; add</Button>
          <Button variant="ghost">Use a Tier-A agent instead</Button>
        </>
      }
      sub="Tier-A agents (claude-code, codex, opencode, qwen) stay fully local. Tier-B/C leave the device — the egress-lock is disabled for them."
    />
  );
}
