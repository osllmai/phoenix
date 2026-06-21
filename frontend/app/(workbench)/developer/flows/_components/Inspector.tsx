'use client';

import { useState } from 'react';

import s from '../page.module.css';

export default function Inspector() {
  const [approveWrites, setApproveWrites] = useState(true);
  const [timeout, setTimeoutToggle] = useState(false);

  return (
    <aside className={s.inspector}>
      <div className={s.inspHead}>
        <span className={s.inspKind}>🤖 Agent node</span>
      </div>
      <h3 className={s.inspTitle}>claude-code: draft</h3>

      <div className={s.fld}>
        <label>Node name</label>
        <input defaultValue="claude-code: draft" />
      </div>
      <div className={s.fld}>
        <label>Agent</label>
        <select defaultValue="claude-code (Tier A · local)">
          <option>claude-code (Tier A · local)</option>
          <option>codex</option>
          <option>phoenix-code (native)</option>
          <option>Conductor (full orchestra)</option>
        </select>
        <div className={s.help}>Points at the local gateway — egress-locked container.</div>
      </div>
      <div className={s.fld}>
        <label>Model</label>
        <select defaultValue="local · llama-3-70b">
          <option>local · llama-3-70b</option>
          <option>local · qwen2.5-coder-32b</option>
          <option>IndoxHub · cloud (opt-in)</option>
        </select>
      </div>
      <div className={s.fld}>
        <label>Task prompt</label>
        <textarea defaultValue="Draft a technical brief from the search results. Cite sources. Output markdown." />
      </div>

      <div className={s.inspSec}>Parameters</div>
      <div className={s.fld}>
        <label>Temperature</label>
        <input defaultValue="0.4" />
      </div>
      <div className={s.fld}>
        <label>Workspace</label>
        <select defaultValue="read-only (worktree)">
          <option>read-only (worktree)</option>
          <option>read-write (grant)</option>
        </select>
      </div>
      <div className={s.portrow}>
        <button
          type="button"
          className={`${s.toggle} ${approveWrites ? s.toggleOn : ''}`}
          onClick={() => setApproveWrites((v) => !v)}
        >
          ✋ approve writes
        </button>
        <button
          type="button"
          className={`${s.toggle} ${timeout ? s.toggleOn : ''}`}
          onClick={() => setTimeoutToggle((v) => !v)}
        >
          ⏱ timeout 5m
        </button>
      </div>

      <div className={s.inspSec}>Ports</div>
      <div className={s.fld}>
        <label>in ← phoenix-search</label>
        <input value="search.results" readOnly />
      </div>
      <div className={s.fld}>
        <label>out → Ragas: faithful?</label>
        <input value="draft.text" readOnly />
      </div>
    </aside>
  );
}
