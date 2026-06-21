'use client';

import { useState } from 'react';

import s from '../page.module.css';
import { API_KEYS, LANGCHAIN_SNIPPET, SNIPPETS, SNIPPET_TABS, type SnippetTab } from './sampleData';

export function ApiKeys() {
  return (
    <div className={s.card}>
      <div className={s.cardHead}>
        <h3>API keys</h3>
        <span className={s.grow} />
        <button className={`${s.btnSm} ${s.headBtn}`} type="button">
          ＋ Create key
        </button>
      </div>
      <div className={s.cardBody}>
        {API_KEYS.map((k) => (
          <div className={s.keyRow} key={k.masked}>
            <span className={s.keyMono}>{k.masked}</span>
            <div className={s.keyMeta}>
              <span>
                <strong>Created</strong> {k.created}
              </span>
              <span>
                <strong>Last used</strong> {k.lastUsed}
              </span>
              <span>
                <strong>Label</strong> {k.label}
              </span>
            </div>
            <div className={s.keyActions}>
              <button className={s.btnSm} type="button">
                Copy
              </button>
              <button className={s.btnDanger} type="button">
                Revoke
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

export function QuickStart() {
  const [tab, setTab] = useState<SnippetTab>('curl');
  return (
    <div className={s.card}>
      <div className={s.cardHead}>
        <h3>Quick start</h3>
        <span className={s.grow} />
        <button className={`${s.btnSm} ${s.headBtn}`} type="button">
          ⚡ Set up Claude Code / SDK
        </button>
      </div>
      <div className={s.cardBody}>
        <p className={s.lead}>
          One click mints a scoped key and drops a ready-to-paste config below — no copy-URL →
          create-key → copy-key dance.
        </p>
        <div className={s.tabbar}>
          {SNIPPET_TABS.map((t) => (
            <button
              className={tab === t ? s.tabOn : ''}
              type="button"
              key={t}
              onClick={() => setTab(t)}
            >
              {t}
            </button>
          ))}
        </div>
        <div className={s.codeWrap}>
          <button className={`${s.btnSm} ${s.copyFab}`} type="button">
            Copy
          </button>
          <pre className={s.codeBlock}>{SNIPPETS[tab]}</pre>
        </div>
      </div>
    </div>
  );
}

export function LangChainCard() {
  return (
    <div className={s.card}>
      <div className={s.cardHead}>
        <h3>Use from LangChain / LlamaIndex</h3>
        <span className={s.grow} />
        <span className={s.hint}>not an install — they point at this gateway</span>
      </div>
      <div className={s.cardBody}>
        <div className={s.codeWrap}>
          <button className={`${s.btnSm} ${s.copyFab}`} type="button">
            Copy
          </button>
          <pre className={s.codeBlock}>{LANGCHAIN_SNIPPET}</pre>
        </div>
      </div>
    </div>
  );
}
