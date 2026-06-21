'use client';

import { Button, CenterState } from '@/app/components/ui';

import s from '../page.module.css';

export function PrivacyNote() {
  return (
    <div className={s.privacyNote}>
      <span className={s.lock}>🔒</span>
      <span>Keys are stored locally in the OS keychain — encrypted, never synced, never hardcoded.</span>
      <span className={s.grow} />
      <span>Need zero keys and full privacy? Use Local inference.</span>
    </div>
  );
}

export function EmptyView({ onConnect }: { onConnect?: () => void }) {
  return (
    <CenterState
      icon="🔌"
      title="No providers configured"
      description="Add a provider key or connect IndoxHub to use cloud models. Prompts leave your machine only when you call a cloud provider."
      sub="Want fully private inference? No key needed on the Local tab."
    >
      <div className={s.btnRow} style={{ justifyContent: 'center' }}>
        <Button onClick={onConnect}>Connect IndoxHub</Button>
        <Button variant="ghost" onClick={onConnect}>
          Add provider key (BYOK)
        </Button>
      </div>
    </CenterState>
  );
}

export function FirstRunView({ onConnect }: { onConnect?: () => void }) {
  return (
    <CenterState
      icon="🔑"
      title="Add your first provider"
      description="Use IndoxHub for instant access to every provider with one key, or add individual BYOK keys and pay providers directly."
      sub="🔒 Keys are stored locally and encrypted. Prefer no keys at all? Run Local models."
    >
      <div className={s.paths}>
        <div className={s.pathCard}>
          <div className={s.pathIcon}>🔀</div>
          <h3>IndoxHub</h3>
          <p>One key routes to OpenAI, Anthropic, Google, Mistral and more. Pay with IndoxHub credits.</p>
          <Button onClick={onConnect}>Connect IndoxHub</Button>
        </div>
        <div className={s.pathCard}>
          <div className={s.pathIcon}>🔑</div>
          <h3>BYOK — your own keys</h3>
          <p>Add a key (or a custom OpenAI-compatible base URL) per provider. You pay the provider directly.</p>
          <Button variant="ghost" onClick={onConnect}>
            Add provider key
          </Button>
        </div>
      </div>
    </CenterState>
  );
}
