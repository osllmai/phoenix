'use client';

import { LANES, type Lane, type LaneLine, type LaneStatus } from './sampleData';
import s from '../page.module.css';

const LANE_CLASS: Record<LaneStatus, string> = {
  run: s.termRun,
  done: s.termDone,
  queued: s.termQueued,
  failed: s.termFailed,
};

const PILL_CLASS: Record<LaneStatus, string> = {
  run: s.pRun,
  done: s.pDone,
  queued: s.pQueued,
  failed: s.pFailed,
};

const TONE_CLASS: Record<NonNullable<LaneLine['tone']>, string> = {
  pr: s.tonePr,
  ok: s.toneOk,
  er: s.toneEr,
  dim: s.toneDim,
  add: s.toneAdd,
};

function LaneCard({
  lane,
  focused,
  onFocus,
}: {
  lane: Lane;
  focused: boolean;
  onFocus: () => void;
}) {
  return (
    <div className={`${s.term} ${LANE_CLASS[lane.status]} ${focused ? s.termFocused : ''}`}>
      <div className={s.termBar}>
        <span className={s.sdot} aria-hidden />
        <span className={s.termName}>{lane.name}</span>
        <span className={s.termRole}>{lane.role}</span>
        <span className={s.grow} />
        <span className={`${s.pill} ${PILL_CLASS[lane.status]}`} role="status">
          {lane.pillLabel}
        </span>
      </div>
      <div className={s.termBody}>
        {lane.lines.map((ln, i) => (
          <div key={i} className={`${s.ln} ${ln.tone ? TONE_CLASS[ln.tone] : ''}`}>
            {ln.text}
            {ln.caret && <span className={s.caret} />}
          </div>
        ))}
      </div>
      <div className={s.termFoot}>
        <span className={s.diffstat}>
          {lane.add != null ? (
            <>
              <span className={s.add}>+{lane.add}</span> <span className={s.del}>−{lane.del}</span> ·{' '}
              {lane.files} files
            </>
          ) : (
            '—'
          )}
        </span>
        <span className={s.lmeta}>
          {lane.elapsed} ·{' '}
          <span className={`${s.route} ${lane.route === 'denied' ? s.routeCloud : ''}`}>
            {lane.routeLabel}
          </span>
          {lane.cost ? ` · ${lane.cost}` : ''}
        </span>
        <span className={s.grow} />
        <button
          className={`${s.minibtn} ${focused ? s.minibtnOn : ''}`}
          type="button"
          title="Focus this lane"
          aria-pressed={focused}
          onClick={onFocus}
        >
          ⤢
        </button>
        <button className={s.minibtn} type="button">
          {lane.footBtn}
        </button>
      </div>
    </div>
  );
}

export default function LaneGrid({
  focused,
  onFocus,
}: {
  focused: string | null;
  onFocus: (name: string | null) => void;
}) {
  return (
    <>
      <div className={s.seclbl}>
        Live lanes · same prompt, isolated worktrees
        <span className={s.grow} />
        <span className={s.seclblNote}>auto-stop on first green ✓</span>
      </div>
      <div className={s.lanes}>
        {LANES.map((lane) => (
          <LaneCard
            key={lane.name}
            lane={lane}
            focused={focused === lane.name}
            onFocus={() => onFocus(focused === lane.name ? null : lane.name)}
          />
        ))}
      </div>
    </>
  );
}
