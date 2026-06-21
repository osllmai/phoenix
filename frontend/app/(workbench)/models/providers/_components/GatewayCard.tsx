'use client';

import { useState } from 'react';

import { Button } from '@/app/components/ui';

import { GATEWAY } from './sampleData';
import s from '../page.module.css';

export function GatewayConnected() {
  const [show, setShow] = useState(false);
  return (
    <div className={`${s.gwCard} ${s.gwConnected}`}>
      <div className={s.gwTop}>
        <div className={s.gwIcon}>🔀</div>
        <div className={s.gwInfo}>
          <h2 className={s.gwTitle}>
            {GATEWAY.name} <span className={s.keyBadge + ' ' + s.badgeVia}>Default</span>
          </h2>
          <p className={s.gwSub}>{GATEWAY.tagline}</p>
        </div>
        <span className={`${s.connPill} ${s.pillOk}`}>
          <span className={s.connDot} />
          Connected
        </span>
      </div>

      <div className={s.keyRow}>
        <div className={s.keyInputWrap}>
          <input
            className={s.keyInput}
            type={show ? 'text' : 'password'}
            value={GATEWAY.sampleKey}
            readOnly
            aria-label="IndoxHub API key"
          />
        </div>
        <button className={s.reveal} type="button" onClick={() => setShow((v) => !v)}>
          {show ? 'Hide' : 'Show'}
        </button>
        <Button variant="ghost">Test</Button>
        <Button variant="ghost">Edit key</Button>
      </div>

      <div className={s.creditsRow}>
        <div className={s.creditStat}>
          <span className={s.creditLabel}>Credits remaining</span>
          <span className={s.creditVal}>{GATEWAY.creditsRemaining}</span>
        </div>
        <div className={s.creditStat}>
          <span className={s.creditLabel}>Used this month</span>
          <span className={s.creditVal}>{GATEWAY.usedThisMonth}</span>
        </div>
        <div className={s.usageWrap}>
          <div className={s.creditLabel}>{GATEWAY.usedPercent}% used</div>
          <div className={s.usageBg}>
            <div className={s.usageFill} style={{ width: `${GATEWAY.usedPercent}%` }} />
          </div>
        </div>
        <Button variant="ghost">Top up</Button>
      </div>
    </div>
  );
}

export function GatewayError({
  pill,
  heading,
  message,
  primary,
  secondary,
  onPrimary,
}: {
  pill: string;
  heading: string;
  message: string;
  primary: string;
  secondary: string;
  onPrimary?: () => void;
}) {
  return (
    <div className={`${s.gwCard} ${s.gwError}`}>
      <div className={s.gwTop}>
        <div className={`${s.gwIcon} ${s.gwIconError}`}>🔀</div>
        <div className={s.gwInfo}>
          <h2 className={s.gwTitle}>{GATEWAY.name}</h2>
          <p className={s.gwSub}>Connect once — reach every provider through IndoxHub.</p>
        </div>
        <span className={`${s.connPill} ${s.pillErr}`}>
          <span className={s.connDot} />
          {pill}
        </span>
      </div>
      <div className={s.errbox}>
        {heading}
        <br />
        <span className={s.dim}>{message}</span>
      </div>
      <div className={s.btnRow}>
        <Button onClick={onPrimary}>{primary}</Button>
        <Button variant="ghost">{secondary}</Button>
      </div>
    </div>
  );
}
