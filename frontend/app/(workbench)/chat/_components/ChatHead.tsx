'use client';

import type { ReactNode } from 'react';

import s from '../page.module.css';
import { ModelPicker } from './ChatTop';

export function ChatHead({
  onCloud,
  badges,
  picker,
}: {
  onCloud: () => void;
  badges?: ReactNode;
  picker?: ReactNode;
}) {
  return (
    <div className={s.sysbar} style={{ background: 'transparent', padding: 'var(--sp-3) var(--sp-5)' }}>
      {picker ?? <ModelPicker onCloud={onCloud} />}
      {badges}
      <span style={{ flex: 1 }} />
      <button className={s.iconbtn} title="Conversation parameters">
        ⚙
      </button>
    </div>
  );
}

export function StaticPicker({ label, dotColor }: { label: string; dotColor?: string }) {
  return (
    <button className={s.modelpick}>
      <span className={s.dot} style={dotColor ? { background: dotColor } : undefined} /> {label} ▾
    </button>
  );
}

export function CloudConfirm({ open, onClose }: { open: boolean; onClose: () => void }) {
  if (!open) return null;
  return (
    <div
      style={{
        position: 'fixed',
        inset: 0,
        zIndex: 80,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        background: 'rgba(0,0,0,.5)',
      }}
      onClick={onClose}
    >
      <div
        onClick={(e) => e.stopPropagation()}
        style={{
          maxWidth: 380,
          background: 'var(--surface-card)',
          border: '1px solid var(--warning-base)',
          borderRadius: 'var(--r-lg)',
          padding: 'var(--sp-4)',
          boxShadow: 'var(--shadow-lg)',
        }}
      >
        <h3 style={{ margin: '0 0 var(--sp-2)', color: 'var(--warning-ink)' }}>
          ⬆ This model runs in the cloud
        </h3>
        <p style={{ margin: '0 0 var(--sp-3)', fontSize: 'var(--fs-sm)', color: 'var(--text-secondary)' }}>
          Sending to a cloud model means your prompt <b>leaves this device</b> and is processed by
          IndoxHub. Local models keep everything on-device.
        </p>
        <div className={s.btnrow} style={{ justifyContent: 'flex-end' }}>
          <button className={s.ghost} onClick={onClose}>
            Stay on-device
          </button>
          <button className={s.cta} onClick={onClose}>
            Use cloud model
          </button>
        </div>
      </div>
    </div>
  );
}
