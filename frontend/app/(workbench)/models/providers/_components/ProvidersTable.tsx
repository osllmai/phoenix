'use client';

import { useState } from 'react';

import { DOT_VAR, type Provider } from './sampleData';
import s from '../page.module.css';

function StatusCell({ p }: { p: Provider }) {
  const map: Record<Provider['status'], { cls: string; text: string }> = {
    connected: { cls: s.statusOk, text: '● Connected' },
    disabled: { cls: '', text: '○ Disabled' },
    unconnected: { cls: '', text: '○ Not connected' },
    denied: { cls: s.statusErr, text: '✕ Denied · 401' },
    failed: { cls: s.statusErr, text: '✕ Test failed' },
  };
  const badge =
    p.badge === 'byok'
      ? s.badgeByok
      : p.badge === 'via'
        ? s.badgeVia
        : p.badge === 'local'
          ? s.badgeLocal
          : '';
  const badgeText = p.badge === 'byok' ? 'BYOK' : p.badge === 'via' ? 'IndoxHub' : 'Local network';
  return (
    <div className={s.statusCell}>
      <span className={`${s.statusLine} ${map[p.status].cls}`}>{map[p.status].text}</span>
      {p.badge && <span className={`${s.keyBadge} ${badge}`}>{badgeText}</span>}
    </div>
  );
}

function KeyCell({ p }: { p: Provider }) {
  const [show, setShow] = useState(false);
  if (p.errorChip) {
    return (
      <div className={`${s.apikeyCell} ${s.apikeyCol}`}>
        {p.maskedKey && <span className={s.keyText}>{p.maskedKey}</span>}
        <span className={s.errChip}>{p.errorChip}</span>
        <button className={s.retryLink} type="button">
          {p.retryLabel ?? 'Retry'}
        </button>
      </div>
    );
  }
  if (p.noKeyNote) {
    return (
      <div className={s.apikeyCell}>
        <span className={s.muted}>{p.noKeyNote}</span>
      </div>
    );
  }
  if (p.maskedKey) {
    return (
      <div className={s.apikeyCell}>
        <span className={s.keyText}>{show ? p.maskedKey.replace(/•/g, '·') : p.maskedKey}</span>
        <button className={s.miniIcon} type="button" title="Show / hide" onClick={() => setShow((v) => !v)}>
          👁
        </button>
        <button className={s.miniIcon} type="button" title="Copy">
          ⧉
        </button>
      </div>
    );
  }
  return (
    <div className={s.apikeyCell}>
      <button className={s.addKeyBtn} type="button">
        ＋ Add key
      </button>
    </div>
  );
}

function Row({ p }: { p: Provider }) {
  const rowCls = p.status === 'denied' || p.status === 'failed' ? s.rowErr : p.enabled ? '' : s.rowDimmed;
  return (
    <div className={`${s.row} ${rowCls}`}>
      <div className={s.nameCell}>
        <span className={s.colorDot} style={{ background: DOT_VAR[p.dot] }} />
        <div className={s.provId}>
          <div className={s.provLabel}>{p.label}</div>
          <div className={s.provEndpoint}>{p.endpoint}</div>
        </div>
      </div>
      <StatusCell p={p} />
      <KeyCell p={p} />
      <div>
        {p.models != null ? (
          <>
            <span className={s.modelCount}>{p.models}</span>{' '}
            <span className={s.modelsLink}>Models</span>
          </>
        ) : (
          <span className={s.dash}>—</span>
        )}
      </div>
      <label className={s.toggle}>
        <input type="checkbox" defaultChecked={p.enabled} disabled={p.toggleDisabled} />
        <span className={s.track} />
        <span className={s.thumb} />
      </label>
      <div className={s.rowActions}>
        {p.status === 'unconnected' ? (
          <button className={s.actBtn} type="button">
            Connect
          </button>
        ) : (
          <>
            <button className={s.actBtn} type="button">
              Test
            </button>
            {p.status === 'connected' && (
              <button className={s.actBtn} type="button">
                Default
              </button>
            )}
            <button className={`${s.actBtn} ${s.actDanger}`} type="button" title="Remove">
              ✕
            </button>
          </>
        )}
      </div>
    </div>
  );
}

export default function ProvidersTable({
  providers,
  count,
}: {
  providers: Provider[];
  count?: string;
}) {
  return (
    <div>
      <div className={s.sectionHead}>
        <h2>Provider keys</h2>
        {count && <span className={s.countTag}>{count}</span>}
      </div>
      <div className={s.table}>
        <div className={s.thead}>
          <span>Provider</span>
          <span>Status</span>
          <span>API key · endpoint</span>
          <span>Models</span>
          <span>Enabled</span>
          <span />
        </div>
        {providers.map((p) => (
          <Row key={p.id} p={p} />
        ))}
      </div>
    </div>
  );
}
