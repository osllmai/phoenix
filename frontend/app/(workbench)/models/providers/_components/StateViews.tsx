'use client';

import { Skeleton } from '@/app/components/ui';

import { GatewayConnected, GatewayError } from './GatewayCard';
import { PrivacyNote } from './HeroViews';
import ProvidersTable from './ProvidersTable';
import { SAMPLE_PROVIDERS, type Provider } from './sampleData';
import s from '../page.module.css';

export function SuccessView() {
  return (
    <div className={s.body}>
      <PrivacyNote />
      <GatewayConnected />
      <ProvidersTable providers={SAMPLE_PROVIDERS} count="5 connected · 3 available" />
    </div>
  );
}

export function LoadingView() {
  return (
    <div className={s.body}>
      <div className={s.gwCard}>
        <div className={s.gwTop}>
          <div className={s.gwIcon}>🔀</div>
          <div className={s.gwInfo}>
            <h2 className={s.gwTitle}>IndoxHub gateway</h2>
            <p className={s.gwSub}>Connect once — reach every provider through IndoxHub.</p>
          </div>
          <span className={`${s.connPill} ${s.pillWarn}`}>
            <span className={s.connDot} />
            Testing…
          </span>
        </div>
        <div className={s.spinRow}>
          <span className={s.spinner} />
          <span>Pinging IndoxHub gateway and verifying credits…</span>
        </div>
      </div>
      <div>
        <div className={s.sectionHead}>
          <h2>Provider keys</h2>
        </div>
        <div className={s.skelStack}>
          {[0, 1, 2].map((i) => (
            <div key={i} className={s.skelRow}>
              <Skeleton width={100 - i * 10} height={14} />
              <Skeleton width="100%" height={12} />
              {i === 0 ? <span className={s.spinner} /> : <Skeleton width={110} height={12} />}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

const ERROR_PROVIDERS: Provider[] = [
  {
    id: 'openai',
    label: 'OpenAI',
    endpoint: 'api.openai.com/v1',
    dot: 'success',
    status: 'connected',
    badge: 'byok',
    maskedKey: 'sk-••••••••3a9f',
    models: 12,
    enabled: true,
  },
  {
    id: 'custom',
    label: 'Custom · OpenAI-compatible',
    endpoint: 'https://llm.internal.example/v1',
    dot: 'error',
    status: 'failed',
    badge: 'byok',
    errorChip: 'Connection refused — endpoint unreachable.',
    retryLabel: 'Retry · Edit base URL',
    enabled: true,
  },
  {
    id: 'groq',
    label: 'Groq',
    endpoint: 'api.groq.com/openai/v1',
    dot: 'disabled',
    status: 'unconnected',
    enabled: false,
    toggleDisabled: true,
  },
];

export function ErrorView({ onRetry }: { onRetry?: () => void }) {
  return (
    <div className={s.body}>
      <GatewayError
        pill="Unreachable"
        heading="Couldn't reach api.indoxhub.com — network error / request timed out."
        message="Check your internet connection or proxy, then retry. Connected providers are unaffected."
        primary="Retry connection"
        secondary="Use a connected BYOK provider"
        onPrimary={onRetry}
      />
      <ProvidersTable providers={ERROR_PROVIDERS} />
    </div>
  );
}

const DENIED_PROVIDERS: Provider[] = [
  {
    id: 'openai',
    label: 'OpenAI',
    endpoint: 'api.openai.com/v1',
    dot: 'success',
    status: 'connected',
    badge: 'byok',
    maskedKey: 'sk-••••••••3a9f',
    models: 12,
    enabled: true,
  },
  {
    id: 'anthropic',
    label: 'Anthropic',
    endpoint: 'api.anthropic.com/v1',
    dot: 'error',
    status: 'denied',
    badge: 'byok',
    maskedKey: 'sk-ant-••••7fA',
    errorChip: 'Invalid API key (401) — rejected by Anthropic.',
    retryLabel: 'Update key',
    enabled: false,
  },
  {
    id: 'cohere',
    label: 'Cohere',
    endpoint: 'api.cohere.com/v2',
    dot: 'disabled',
    status: 'unconnected',
    enabled: false,
    toggleDisabled: true,
  },
];

export function DeniedView({ onUpdate }: { onUpdate?: () => void }) {
  return (
    <div className={s.body}>
      <GatewayError
        pill="Invalid key · 401"
        heading="Your IndoxHub API key was rejected (401 Unauthorized) — the key is invalid, revoked, or out of credits."
        message="Update the key or top up your balance to restore access."
        primary="Update IndoxHub key"
        secondary="Top up balance"
        onPrimary={onUpdate}
      />
      <ProvidersTable providers={DENIED_PROVIDERS} />
      <PrivacyNote />
    </div>
  );
}
