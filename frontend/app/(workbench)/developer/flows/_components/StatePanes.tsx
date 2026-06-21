'use client';

import { Button, EmptyState, ErrorState } from '@/app/components/ui';
import { TEMPLATES } from './sampleData';
import s from '../page.module.css';

export function EmptyPane({ onNew }: { onNew: () => void }) {
  return (
    <EmptyState
      icon="🪢"
      title="No flows yet"
      description="Flows let you wire Phoenix's agents, tools, and evaluators into a reusable, node-based scenario — your own n8n for the local orchestra."
      actions={
        <>
          <Button variant="ghost">Browse templates</Button>
          <Button variant="cta" onClick={onNew}>
            ＋ New flow
          </Button>
        </>
      }
    />
  );
}

export function FirstRunPane({ onBlank }: { onBlank: () => void }) {
  return (
    <div className={s.center}>
      <div className={s.centerBig}>✨</div>
      <h2>Start from a template</h2>
      <p>Pick a starting scenario and tweak it on the canvas, or start from a blank flow.</p>
      <div className={s.tmplGrid}>
        {TEMPLATES.map((t) => (
          <button key={t.id} type="button" className={s.tmpl}>
            <span className={s.tt}>{t.title}</span>
            <span className={s.td}>{t.description}</span>
            <span className={s.flowmini}>{t.mini}</span>
          </button>
        ))}
      </div>
      <div className={s.btnrow}>
        <Button variant="cta" onClick={onBlank}>
          ＋ Start blank
        </Button>
      </div>
      <p className={s.sub}>
        The Flow builder is an opt-in <code>FeatureModule</code> extension — local-first, like the rest.
      </p>
    </div>
  );
}

export function DeniedPane() {
  return (
    <ErrorState
      icon="🔐"
      title="Node needs access"
      variant="warning"
      heading="codex: revise — account / permission required"
      message="This node uses a Tier-C agent that needs a vendor account to start, or write access to a workspace it hasn't been granted. The egress-lock is off for cloud-tier nodes — they leave the device."
      actions={
        <>
          <Button variant="cta">Connect account</Button>
          <Button variant="ghost">Grant write access</Button>
          <Button variant="ghost">Swap for a Tier-A agent</Button>
        </>
      }
      sub={
        <>
          Tier-A (local) nodes run offline with no account. Cloud / login-gated nodes are badged and
          prompt on first use — set keys in <code>Settings</code> (OS keychain).
        </>
      }
    />
  );
}
