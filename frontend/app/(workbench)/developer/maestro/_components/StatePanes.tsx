'use client';

import { useState } from 'react';

import { Button, CenterState, EmptyState, ErrorState, Skeleton } from '@/app/components/ui';

import { ROSTER, SAMPLE_GOAL } from './sampleData';
import s from '../page.module.css';

export function EmptyPane() {
  return (
    <EmptyState
      icon="🎻"
      title="No agents installed"
      description="The orchestra is empty. Maestro only conducts agents you've installed and enabled. Add a performer agent from the marketplace to begin."
      actions={
        <>
          <Button>Browse Developer agents →</Button>
          <Button variant="ghost">What is Maestro?</Button>
        </>
      }
    />
  );
}

export function FirstRunPane({ onRun }: { onRun: () => void }) {
  const [roster, setRoster] = useState(ROSTER);
  const toggle = (name: string) =>
    setRoster((prev) => prev.map((a) => (a.name === name ? { ...a, on: !a.on } : a)));

  return (
    <CenterState
      icon="🎼"
      title="Assemble your orchestra"
      description="Just type a goal and run — Maestro starts with a recommended orchestra (claude-code + codex). Or fine-tune the roster below."
    >
      <input className={s.firstgoal} placeholder={`e.g. ${SAMPLE_GOAL}`} />
      <div className={s.btnrow}>
        <Button onClick={onRun}>▶ Run with recommended agents</Button>
      </div>
      <p className={s.sub}>Recommended: claude-code (plan) · codex (impl/tests) — change anytime.</p>
      <div className={`${s.seclbl} ${s.seclblCenter}`}>or pick your own roster</div>
      <div className={s.picker}>
        {roster.map((a) => (
          <button
            key={a.name}
            type="button"
            className={`${s.agentcard} ${a.on ? s.agentOn : ''}`}
            onClick={() => toggle(a.name)}
          >
            {a.icon} {a.name}
            <span className={s.tier}>{a.tier}</span>
          </button>
        ))}
      </div>
      <input className={s.firstgoal} placeholder={`e.g. ${SAMPLE_GOAL}`} />
      <div className={s.btnrow}>
        <Button onClick={onRun}>▶ Run first goal</Button>
      </div>
      <p className={s.sub}>
        Each agent runs in its own sandboxed, egress-locked container · nothing leaves the device.
      </p>
    </CenterState>
  );
}

export function LoadingPane() {
  const rows = [
    [45, 90, 70, 80],
    [40, 85, 60, 75],
    [50, 65, 88],
    [38, 72, 55],
  ];
  return (
    <div className={s.gridpane}>
      <div className={s.loadingNote}>
        Spinning up agent containers…{' '}
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
      title="An agent failed"
      heading="codex · impl — container exited (code 137)"
      message="The codex container was OOM-killed mid-task. Its worktree edits were rolled back. Other agents are unaffected and the plan is paused."
      actions={
        <>
          <Button>↻ Retry codex</Button>
          <Button variant="ghost">Reassign step → claude-code</Button>
          <Button variant="ghost">View logs</Button>
        </>
      }
      sub="Raise the container memory limit in agent settings, or hand the step to another performer."
    />
  );
}

export function DeniedPane() {
  return (
    <ErrorState
      icon="🚫"
      variant="warning"
      title="Agent can't start"
      heading="droid · Tier C — account required"
      message="Factory Droid needs a Factory account to authenticate, and it routes some subagents to the cloud. It can't join a Tier-A (offline, egress-locked) run until you sign in and allow cloud egress."
      actions={
        <>
          <Button>Sign in &amp; allow cloud</Button>
          <Button variant="ghost">Use a Tier-A agent instead</Button>
        </>
      }
      sub="Tier-B/C agents leave the device — the egress-lock is disabled for them. Tier-A agents stay fully local."
    />
  );
}
