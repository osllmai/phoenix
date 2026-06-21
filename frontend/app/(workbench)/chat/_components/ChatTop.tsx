'use client';

import { useState, type ReactNode } from 'react';

import s from '../page.module.css';
import { CLOUD_MODELS, LOCAL_MODELS } from './data';

export function TopBar({ children }: { children: ReactNode }) {
  return (
    <div className={s.sysbar} style={{ borderBottom: 'none', background: 'transparent', padding: 'var(--sp-3) var(--sp-5)' }}>
      {children}
    </div>
  );
}

export function ModelPicker({ onCloud }: { onCloud: () => void }) {
  const [open, setOpen] = useState(false);
  return (
    <div className={s.modelpickWrap}>
      <button className={s.modelpick} onClick={() => setOpen((v) => !v)}>
        <span className={s.dot} /> Llama-3.1-8B-Instruct · Q4_K_M ▾
      </button>
      {open && (
        <div className={s.modelMenu}>
          <div className={s.mmGroup}>Local · on-device</div>
          {LOCAL_MODELS.map((m) => (
            <button key={m.name} className={`${s.mmItem} ${m.active ? s.mmActive : ''}`}>
              <span className={s.dot} style={m.dim ? { background: 'var(--text-disabled)' } : undefined} />
              {m.name}
              <span className={s.mmMeta}>{m.size}</span>
            </button>
          ))}
          <button className={s.mmItem}>＋ Browse &amp; download GGUF…</button>
          <div className={s.mmGroup}>Online · IndoxHub (cloud)</div>
          {CLOUD_MODELS.map((m) => (
            <button key={m.name} className={`${s.mmItem} ${s.mmCloud}`} onClick={onCloud}>
              <span className={s.dot} style={{ background: m.dotColor }} />
              {m.name}
              <span className={s.leaves}>⬆ leaves device</span>
              <span className={s.mmMeta}>api</span>
            </button>
          ))}
          <div className={s.mmNote}>
            Local models keep prompts on-device. Cloud models send your prompt to IndoxHub.
          </div>
        </div>
      )}
    </div>
  );
}

export function SysBar() {
  return (
    <div className={s.sysbar}>
      <span className={s.sysIco}>⚙ System</span>
      <span className={s.sysText}>
        You are Phoenix, a concise local coding assistant. Prefer Dart examples.
      </span>
      <button className={s.sysEdit}>Edit</button>
    </div>
  );
}
