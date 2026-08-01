'use client';

import { DISK_USAGE, DOCUMENT_STORE_SUMMARY, VERSIONS } from '../sample';
import type { SettingsForm } from './useSettingsForm';
import { Block, Field, Toggle } from './fields';
import { AboutActions, ClearCachesButton, ManageButton, RevealButton } from './SectionActions';
import s from '../page.module.css';

export function Privacy({ f }: { f: SettingsForm }) {
  return (
    <>
      <h2 className={`${s.sectionTitle} ${s.sectionTitleGap}`} id="privacy">Privacy &amp; Data</h2>
      <Block>
        <div className={s.privacyNote}>
          <span className={s.ico}>🔒</span>
          <p>
            Inference runs entirely on-device — prompts and responses never leave your machine. No
            account, no telemetry unless you opt in below.
          </p>
        </div>
        <Field name="Telemetry" desc="Anonymous crash reports — no prompts included">
          <Toggle on={f.telemetry} onChange={f.setTelemetry} />
        </Field>
        <Field name="Usage analytics" desc="Feature interactions (no conversation content)">
          <Toggle on={f.analytics} onChange={f.setAnalytics} />
        </Field>
        <Field name="Data location" desc="Where conversations and metadata live">
          <input
            className={s.textInput}
            type="text"
            value={f.dataLocation}
            onChange={(e) => f.setDataLocation(e.target.value)}
          />
          <RevealButton path={f.dataLocation} />
        </Field>
      </Block>
    </>
  );
}

export function Storage() {
  return (
    <>
      <h2 className={`${s.sectionTitle} ${s.sectionTitleGap}`} id="storage">Storage</h2>
      <Block head="Disk usage">
        {DISK_USAGE.map((d) => (
          <div className={s.meter} key={d.label}>
            <span className={s.meterLabel}>{d.label}</span>
            <span className={s.meterTrack}>
              <span className={s.meterFill} style={{ width: `${d.pct}%` }} />
            </span>
            <span className={s.meterVal}>{d.value}</span>
          </div>
        ))}
      </Block>
      <Block>
        <Field name="Document store" desc="Converted markdown + embeddings index">
          <span className={s.staticVal}>{DOCUMENT_STORE_SUMMARY}</span>
          <ManageButton />
        </Field>
        <Field name="Clear caches" desc="KV-cache and thumbnails (1.2 GB) — models kept">
          <ClearCachesButton />
        </Field>
      </Block>
    </>
  );
}

export function Backend({ f }: { f: SettingsForm }) {
  const postgres = f.database === 'Postgres';
  return (
    <>
      <h2 className={`${s.sectionTitle} ${s.sectionTitleGap}`} id="backend">Backend</h2>
      <p className={s.sub}>Storage engine and local HTTP gateway.</p>
      <Block>
        <Field name="Database" desc="Conversation & model metadata storage">
          <div className={s.radioGroup}>
            {['SQLite (on-device)', 'Postgres'].map((db) => (
              <label key={db} className={`${s.radioPill} ${f.database === db ? s.sel : ''}`}>
                <input
                  type="radio"
                  name="db"
                  checked={f.database === db}
                  onChange={() => f.setDatabase(db)}
                />
                {db}
              </label>
            ))}
          </div>
        </Field>
        <Field name="DATABASE_URL" desc="Used only when Postgres is selected">
          <input
            className={s.textInput}
            type="url"
            placeholder="postgresql://user:pass@localhost:5432/phoenix"
            value={f.databaseUrl}
            onChange={(e) => f.setDatabaseUrl(e.target.value)}
            disabled={!postgres}
          />
        </Field>
        <Field name="Server port" desc="Local OpenAI/Anthropic-compatible gateway">
          <input
            className={`${s.input} ${s.numberInput}`}
            type="number"
            min={1024}
            max={65535}
            value={f.serverPort}
            onChange={(e) => f.setServerPort(e.target.value)}
          />
        </Field>
      </Block>
    </>
  );
}

export function About() {
  return (
    <>
      <h2 className={`${s.sectionTitle} ${s.sectionTitleGap}`} id="about">About</h2>
      <Block>
        {VERSIONS.map((v) => (
          <div className={s.versionRow} key={v.key}>
            <span className={s.versionKey}>{v.key}</span>
            <span className={s.versionVal}>{v.value}</span>
          </div>
        ))}
      </Block>
      <AboutActions />
    </>
  );
}
