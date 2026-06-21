'use client';

import { CenterState, ErrorState, Button, Skeleton } from '@/app/components/ui';
import s from '../page.module.css';

export function EmptyPane({ onClear }: { onClear: () => void }) {
  return (
    <CenterState
      icon="🔍"
      title="No models match"
      description={
        <>
          No hosted models match <strong>“claude-haiku-4”</strong> with the{' '}
          <strong>Vision</strong> filter on. Clear your filters, broaden the search, or pick another
          provider from the rail.
        </>
      }
    >
      <div className={s.btnrow}>
        <Button variant="ghost" onClick={onClear}>
          Clear filters
        </Button>
        <Button>All providers</Button>
      </div>
    </CenterState>
  );
}

export function FirstRunPane() {
  return (
    <CenterState
      icon="☁️"
      title="Connect IndoxHub"
      description="IndoxHub is a cloud LLM gateway — one key routes to OpenAI, Anthropic, Google, Mistral, and more. Models run on remote servers, not on-device; your prompts leave your machine."
      sub="Want fully private inference? Switch to the Local tab."
    >
      <div className={s.keyform}>
        <div>
          <label htmlFor="ir-key">IndoxHub API key</label>
          <input id="ir-key" type="password" placeholder="ir-…" autoComplete="off" />
        </div>
        <div className={s.note}>
          <strong>IndoxHub key:</strong> bills your IndoxHub account credits.
          <br />
          <strong>BYOK:</strong> enter your own provider key — IndoxHub routes it, you pay the
          provider.
        </div>
        <Button className={s.keyformCta}>Connect</Button>
      </div>
    </CenterState>
  );
}

export function LoadingPane() {
  return (
    <div className={s.content}>
      <aside className={s.provlist}>
        <div className={s.provHead}>Providers</div>
        {['OpenAI', 'Anthropic', 'Google'].map((p, i) => (
          <div key={p} className={`${s.prov} ${i === 0 ? s.provSel : s.provAvail}`}>
            <span
              className={s.provDot}
              style={{ background: i === 0 ? 'var(--warning-base)' : 'var(--text-disabled)' }}
            />
            <span className={s.provName}>{p}</span>
            <span className={s.provCount}>—</span>
          </div>
        ))}
      </aside>
      <div className={s.panel}>
        <div className={s.loadingRow}>
          <span className={s.spinner} />
          <span className={s.loadingText}>Fetching model catalog from IndoxHub…</span>
        </div>
        {[40, 35, 45].map((w, i) => (
          <div key={i} className={s.skelCard}>
            <Skeleton width={`${w}%`} height={16} />
            <Skeleton width="70%" />
            <Skeleton width="55%" />
          </div>
        ))}
      </div>
    </div>
  );
}

export function ErrorPane({ onRetry }: { onRetry: () => void }) {
  return (
    <ErrorState
      icon="⚡"
      title="Router unreachable"
      heading="Could not reach IndoxHub"
      message="ETIMEDOUT connecting to the IndoxHub gateway. Check your internet connection or the IndoxHub service status, then try again."
      actions={
        <>
          <Button onClick={onRetry}>Retry</Button>
          <Button variant="ghost">Open settings</Button>
        </>
      }
    />
  );
}

export function DeniedPane() {
  return (
    <ErrorState
      icon="🔒"
      variant="warning"
      title="API key invalid or unauthorized"
      heading="401 Unauthorized"
      message="Your IndoxHub API key is missing, invalid, or revoked. Add or update the key on the Providers tab, top up credits, or switch to BYOK."
      sub="The catalog can’t load until a valid key is configured."
      actions={
        <>
          <Button>Fix in Providers</Button>
          <Button variant="ghost">Switch to BYOK</Button>
        </>
      }
    />
  );
}
