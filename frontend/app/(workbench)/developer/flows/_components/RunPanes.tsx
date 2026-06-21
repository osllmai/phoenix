'use client';

import RunBuilder from './RunBuilder';
import type { FlowNode, FlowWire } from './sampleData';
import { FLOW_NAME } from './sampleData';
import s from '../page.module.css';

const LOADING_NODES: FlowNode[] = [
  { id: 'trigger', kind: 'trigger', head: 'Trigger', headIcon: '⚡', title: 'Manual run', status: 'done', statusLabel: '✓ fired', x: 20, y: 48 },
  { id: 'search', kind: 'tool', head: 'Tool', headIcon: '🔎', title: 'phoenix-search', status: 'done', statusLabel: '✓ 8 sources', x: 268, y: 48 },
  { id: 'draft', kind: 'agent', head: 'Agent', headIcon: '🤖', title: 'claude-code: draft', sub: 'streaming… 1,240 tok', status: 'run', statusLabel: '⟳ running', x: 516, y: 48, running: true },
  { id: 'gate', kind: 'eval', head: 'Evaluator · gate', headIcon: '⚖', title: 'Ragas: faithful?', status: 'idle', statusLabel: '• waiting', x: 800, y: 212 },
];

const LOADING_WIRES: FlowWire[] = [
  { id: 'w1', kind: 'ok', d: 'M 188 78 C 230 78, 230 78, 268 78' },
  { id: 'w2', kind: 'ok', d: 'M 436 78 C 478 78, 478 78, 516 78' },
  { id: 'w3', kind: 'plain', d: 'M 684 78 C 740 78, 740 250, 800 250' },
];

const ERROR_NODES: FlowNode[] = [
  { id: 'trigger', kind: 'trigger', head: 'Trigger', headIcon: '⚡', title: 'Manual run', status: 'done', statusLabel: '✓ fired', x: 20, y: 48 },
  { id: 'search', kind: 'tool', head: 'Tool', headIcon: '🔎', title: 'phoenix-search', status: 'done', statusLabel: '✓ done', x: 268, y: 48 },
  { id: 'draft', kind: 'agent', head: 'Agent', headIcon: '🤖', title: 'claude-code: draft', sub: 'container exited (137)', status: 'fail', statusLabel: '✕ failed', x: 516, y: 48, errored: true },
];

const ERROR_WIRES: FlowWire[] = [
  { id: 'w1', kind: 'ok', d: 'M 188 78 C 230 78, 230 78, 268 78' },
  { id: 'w2', kind: 'warn', d: 'M 436 78 C 478 78, 478 78, 516 78' },
];

export function LoadingPane() {
  return (
    <>
      <div className={s.top}>
        <h1 className={s.flowname}>{FLOW_NAME}</h1>
        <span className={s.grow} />
        <span className={s.runstate}>
          <span className={`${s.dot} ${s.dotWarn}`} /> running · step 2 of 6
        </span>
        <button type="button" className={s.ghost}>⏸ Pause</button>
        <button type="button" className={s.ghost}>⏹ Stop</button>
      </div>
      <RunBuilder
        progress={[
          { icon: '⚡', label: 'Manual run', mark: '✓', markClass: s.markOk },
          { icon: '🔎', label: 'phoenix-search', mark: '✓', markClass: s.markOk },
          { icon: '🤖', label: 'claude-code: draft', mark: '⠿', markClass: s.markWarn },
          { icon: '⚖', label: 'Ragas: faithful?', mark: '•' },
          { icon: '📤', label: 'Write file', mark: '•' },
        ]}
        nodes={LOADING_NODES}
        wires={LOADING_WIRES}
        inspector={
          <aside className={s.inspector}>
            <div className={s.inspHead}>
              <span className={s.inspKind}>▶ Run trace</span>
            </div>
            <h3 className={s.inspTitle}>Live run</h3>
            <div className={s.fld}><label>Elapsed</label><input value="00:38" readOnly /></div>
            <div className={s.fld}><label>Current node</label><input value="claude-code: draft" readOnly /></div>
            <div className={s.fld}><label>Tokens (this node)</label><input value="1,240 / streaming" readOnly /></div>
            <div className={s.fld}>
              <label>Recent events</label>
              <textarea readOnly value={'search→done (8 src)\nclaude-code→started\nclaude-code→output…'} />
            </div>
          </aside>
        }
      />
    </>
  );
}

export function ErrorPane({ onRetry }: { onRetry: () => void }) {
  return (
    <>
      <div className={s.top}>
        <h1 className={s.flowname}>{FLOW_NAME}</h1>
        <span className={s.grow} />
        <span className={s.runstate}>
          <span className={`${s.dot} ${s.dotErr}`} /> failed at step 3
        </span>
        <button type="button" className={s.ghost} onClick={onRetry}>⟳ Retry node</button>
        <button type="button" className={s.ghost}>⏹ Stop</button>
      </div>
      <RunBuilder
        progress={[
          { icon: '⚡', label: 'Manual run', mark: '✓', markClass: s.markOk },
          { icon: '🔎', label: 'phoenix-search', mark: '✓', markClass: s.markOk },
          { icon: '🤖', label: 'claude-code: draft', mark: '✕', markClass: s.markErr },
        ]}
        nodes={ERROR_NODES}
        wires={ERROR_WIRES}
        inspector={
          <aside className={s.inspector}>
            <div className={s.inspHead}>
              <span className={`${s.inspKind} ${s.inspKindErr}`}>✕ Node failed</span>
            </div>
            <h3 className={s.inspTitle}>claude-code: draft</h3>
            <div className={s.errbox}>
              <h3>Agent container exited (code 137)</h3>
              <p>
                The agent&apos;s egress-locked container was OOM-killed mid-draft. Earlier nodes&apos;
                outputs are saved — the run can resume from this node.
              </p>
              <div className={s.btnrow} style={{ justifyContent: 'flex-start' }}>
                <button type="button" className={s.cta} onClick={onRetry}>Retry node</button>
                <button type="button" className={s.ghost}>View logs</button>
              </div>
            </div>
            <div className={s.fld} style={{ marginTop: 'var(--sp-4)' }}>
              <label>Last event</label>
              <textarea readOnly value={'claude-code→error: OOM (137)\nruntime→node halted\nflow→paused (resumable)'} />
            </div>
          </aside>
        }
      />
    </>
  );
}
