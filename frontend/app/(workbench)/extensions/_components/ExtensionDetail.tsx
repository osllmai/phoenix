'use client';

import { useState } from 'react';

import type { Extension } from './sampleData';
import s from '../page.module.css';

const TABS = ['Overview', 'Features', 'Requirements', 'Changelog'] as const;
type Tab = (typeof TABS)[number];

export default function ExtensionDetail({ ext }: { ext: Extension }) {
  const [tab, setTab] = useState<Tab>('Overview');

  return (
    <div className={s.detail}>
      <div className={s.detHead}>
        <div className={s.detIco}>{ext.icon}</div>
        <div className={s.extBody}>
          <h2 className={s.detTitle}>
            {ext.name}
            {ext.verified && <span className={s.verified}> ✔ verified</span>}
          </h2>
          <div className={s.detMeta}>
            <span>{ext.publisher}</span>
            {ext.rating != null && (
              <span>
                <span className={s.stars}>★</span> {ext.rating}
              </span>
            )}
            {ext.installs && <span>{ext.installs}</span>}
          </div>
          <div className={s.detActions}>
            {ext.installed ? (
              <>
                <button className={s.installed} type="button">
                  ✓ Installed
                </button>
                <button className={s.danger} type="button">
                  Uninstall
                </button>
                <button className={s.ghost} type="button">
                  Disable
                </button>
                <span className={s.autoUpdate}>Auto-update on</span>
              </>
            ) : (
              <button className={s.install} type="button">
                {ext.installLabel ?? 'Install'}
              </button>
            )}
          </div>
        </div>
      </div>

      <div className={s.tabs}>
        {TABS.map((t) => (
          <button
            key={t}
            type="button"
            className={`${s.tab} ${tab === t ? s.tabOn : ''}`}
            onClick={() => setTab(t)}
          >
            {t}
          </button>
        ))}
      </div>

      <div className={s.tabBody}>
        {tab === 'Overview' && (
          <>
            <div className={s.shot}>▢ screenshot — {ext.name}</div>
            <p>{ext.description}</p>
            <h3>Adds to Phoenix</h3>
            <ul>
              <li>A dedicated screen in the rail (library + inspector)</li>
              <li>On-demand backend services, installed only when you need them</li>
              <li>Runs on-device — no data leaves the machine</li>
            </ul>
          </>
        )}
        {tab === 'Features' && (
          <>
            <h3>Capabilities</h3>
            <ul>
              <li>Modular FeatureModule registered into the shell</li>
              <li>Configurable pipelines and export formats</li>
              <li>Frees its disk footprint cleanly on uninstall</li>
            </ul>
          </>
        )}
        {tab === 'Requirements' && (
          <>
            <div className={s.req}>
              <span className={s.reqK}>Install size</span>
              <span className={s.reqV}>{ext.tags.find((t) => t.size)?.label ?? 'Varies'}</span>
            </div>
            <div className={s.req}>
              <span className={s.reqK}>Backend services</span>
              <span className={s.reqV}>Celery worker + extension backend</span>
            </div>
            <div className={s.req}>
              <span className={s.reqK}>Runs</span>
              <span className={s.reqV}>On-device · no data leaves the machine</span>
            </div>
          </>
        )}
        {tab === 'Changelog' && (
          <>
            <h3>Latest — Jun 2026</h3>
            <ul>
              <li>Performance and stability improvements</li>
              <li>New export options</li>
            </ul>
          </>
        )}
      </div>
    </div>
  );
}
