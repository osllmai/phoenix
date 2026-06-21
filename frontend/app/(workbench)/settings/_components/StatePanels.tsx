'use client';

import { useState } from 'react';

import { Button, EmptyState } from '@/app/components/ui';

import { FIRST_RUN_MODELS, LOCKED_FIELDS, SETTINGS_PATH } from '../sample';
import { Block, Field, RadioPills } from './fields';
import { modelsEmptyActions } from './SectionsTop';
import s from '../page.module.css';

export function LoadingPanel() {
  return (
    <div className={s.inner}>
      <div className={`${s.skel} ${s.skelShort}`} style={{ height: 22 }} />
      <div className={s.sub}>Loading settings…</div>
      <div className={`${s.skel} ${s.skelMed}`} /><div className={s.skelField} />
      <div className={`${s.skel} ${s.skelLong}`} /><div className={s.skelField} />
      <div className={`${s.skel} ${s.skelShort}`} style={{ marginTop: 'var(--sp-5)' }} />
      <div className={s.skelField} /><div className={`${s.skel} ${s.skelMed}`} />
      <div className={s.skelField} /><div className={`${s.skel} ${s.skelLong}`} />
      <div className={s.skelField} />
    </div>
  );
}

export function EmptyPanel() {
  return (
    <div className={s.inner}>
      <h2 className={s.sectionTitle}>Models &amp; Inference</h2>
      <p className={s.sub}>Nothing configured here yet.</p>
      <EmptyState
        icon="📭"
        title="No models installed"
        description="There's no default chat or embedding model to configure. Download a GGUF from the catalog and it'll appear here."
        actions={modelsEmptyActions()}
      />
    </div>
  );
}

export function ErrorPanel() {
  return (
    <div className={s.inner}>
      <h2 className={s.sectionTitle}>Models &amp; Inference</h2>
      <div className={`${s.banner} ${s.error}`}>
        <span className={s.bannerIcon}>⚠️</span>
        <div className={s.bannerBody}>
          <strong>Couldn&apos;t save settings</strong>
          Write failed: <code className={s.code}>{SETTINGS_PATH}</code> — disk full or permission
          denied. Free up space or check folder permissions, then retry.
          <div className={s.actions}>
            <Button>Retry</Button>
            <Button variant="ghost">Open storage settings</Button>
          </div>
        </div>
      </div>
    </div>
  );
}

export function DeniedPanel() {
  return (
    <div className={s.inner}>
      <h2 className={s.sectionTitle}>Backend</h2>
      <div className={`${s.banner} ${s.info}`}>
        <span className={s.bannerIcon}>🔒</span>
        <div className={s.bannerBody}>
          <strong>Some settings are managed by policy</strong>
          Your organisation has locked the database and storage settings. Contact your administrator
          to request a change.
        </div>
      </div>
      <Block head="Database">
        {LOCKED_FIELDS.map((l) => (
          <Field key={l.name} name={l.name} desc={l.desc}>
            <div className={s.lockedField}>
              <span className={s.lockIcon}>🔒</span>
              {l.value}
              <span className={s.lockBadge}>{l.badge}</span>
            </div>
          </Field>
        ))}
        <Field name="Clear caches" desc="Disabled in managed mode">
          <button type="button" className={s.btnDanger} disabled>Clear caches…</button>
        </Field>
      </Block>
    </div>
  );
}

export function FirstRunPanel() {
  const [theme, setTheme] = useState('Dark');
  const [model, setModel] = useState('');
  return (
    <div className={s.shell} style={{ alignItems: 'center', justifyContent: 'center' }}>
      <div className={`${s.center} ${s.centerWide}`}>
        <div className={s.centerBig}>🔥</div>
        <h2>Finish setting up Phoenix</h2>
        <p>A few defaults and you&apos;re ready to run models locally. Change any of these later in Settings.</p>
        <ul className={s.stepList}>
          <li>
            <div className={s.stepNum}>1</div>
            <div>
              <div className={s.stepTitle}>Choose your theme</div>
              <div className={s.stepHint}>Warm-charcoal dark by default.</div>
              <div className={s.stepGap}>
                <RadioPills name="fr-theme" value={theme} onChange={setTheme} options={['Dark', 'Cream', 'System']} />
              </div>
            </div>
          </li>
          <li>
            <div className={s.stepNum}>2</div>
            <div>
              <div className={s.stepTitle}>Pick a default model</div>
              <div className={s.stepHint}>Loaded on startup — change later under Models.</div>
              <select
                className={s.modelPicker}
                value={model}
                onChange={(e) => setModel(e.target.value)}
              >
                <option value="">— Select a model —</option>
                {FIRST_RUN_MODELS.map((m) => (
                  <option key={m}>{m}</option>
                ))}
              </select>
            </div>
          </li>
          <li>
            <div className={s.stepNum}>3</div>
            <div>
              <div className={s.stepTitle}>Storage stays on this device</div>
              <div className={s.stepHint}>SQLite + model cache under your app-support folder. Postgres optional later.</div>
            </div>
          </li>
        </ul>
        <div className={s.frActions}>
          <Button>Save &amp; start chatting →</Button>
          <Button variant="ghost">Skip for now</Button>
        </div>
      </div>
    </div>
  );
}
