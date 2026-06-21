import {
  EVENT_LOG,
  SAMPLE_TERMINALS,
  type AgentTerminal,
  type TermLine,
  type TermStatus,
} from './sampleData';
import s from '../page.module.css';

const TERM_CLASS: Record<TermStatus, string> = {
  run: s.termRun,
  queued: s.termQueued,
  done: s.termDone,
  idle: s.termIdle,
  failed: s.termFailed,
};

const PILL_CLASS: Record<TermStatus, string> = {
  run: s.pRun,
  queued: s.pQueued,
  done: s.pDone,
  idle: s.pIdle,
  failed: s.pFailed,
};

const TONE_CLASS: Record<NonNullable<TermLine['tone']>, string> = {
  pr: s.tonePr,
  ok: s.toneOk,
  wn: s.toneWn,
  er: s.toneEr,
  dim: s.toneDim,
};

function Terminal({ term }: { term: AgentTerminal }) {
  return (
    <div className={`${s.term} ${TERM_CLASS[term.status]}`}>
      <div className={s.termBar}>
        <span className={s.sdot} />
        <span className={s.termName}>{term.name}</span>
        <span className={s.termRole}>{term.role}</span>
        <span className={s.grow} />
        <span className={`${s.pill} ${PILL_CLASS[term.status]}`}>{term.pillLabel}</span>
      </div>
      <div className={s.termBody}>
        {term.lines.map((ln, i) => (
          <div key={i} className={`${s.ln} ${ln.tone ? TONE_CLASS[ln.tone] : ''}`}>
            {ln.text}
            {ln.caret && <span className={s.caret} />}
          </div>
        ))}
      </div>
    </div>
  );
}

export default function TerminalGrid() {
  return (
    <div className={s.gridpane}>
      <div className={s.grid}>
        {SAMPLE_TERMINALS.map((term) => (
          <Terminal key={term.name} term={term} />
        ))}
      </div>
      <div className={s.eventlog}>
        <span className={s.evLbl}>events:</span>
        {EVENT_LOG.map((e, i) => (
          <span key={i} className={s.ev}>
            <b>{e.agent}</b>
            {e.rest}
            {i < EVENT_LOG.length - 1 ? ' ·' : ''}
          </span>
        ))}
      </div>
    </div>
  );
}
