'use client';

import { useState } from 'react';

import { Button } from '@/app/components/ui';

import { ADD_PROVIDER_OPTIONS } from './sampleData';
import s from '../page.module.css';

export default function AddDialog({ onClose }: { onClose: () => void }) {
  const [baseUrl, setBaseUrl] = useState('');
  const [apiKey, setApiKey] = useState('');
  const [showKey, setShowKey] = useState(false);
  const [makeDefault, setMakeDefault] = useState(false);

  return (
    <>
      <div className={s.overlay} onClick={onClose} />
      <div className={s.overlayWrap}>
        <div className={s.dialog} role="dialog" aria-modal="true" aria-label="Add provider">
          <div className={s.dialogHead}>
            <h3>Add provider</h3>
            <button className={s.dialogClose} type="button" aria-label="Close" onClick={onClose}>
              ✕
            </button>
          </div>

          <div className={s.field}>
            <label htmlFor="a-provider">Provider</label>
            <select id="a-provider" defaultValue="Custom · OpenAI-compatible">
              {ADD_PROVIDER_OPTIONS.map((o) => (
                <option key={o}>{o}</option>
              ))}
            </select>
          </div>

          <div className={s.field}>
            <label htmlFor="a-base-url">
              Base URL <span className={s.optional}>(custom / self-hosted)</span>
            </label>
            <input
              id="a-base-url"
              type="url"
              value={baseUrl}
              onChange={(e) => setBaseUrl(e.target.value)}
              placeholder="https://api.provider.example/v1"
            />
            <span className={s.hint}>
              Any OpenAI-compatible endpoint works — vLLM, LM Studio, Ollama, or a hosted gateway.
            </span>
          </div>

          <div className={s.field}>
            <label htmlFor="a-apikey">API key</label>
            <div className={s.inputRow}>
              <input
                id="a-apikey"
                type={showKey ? 'text' : 'password'}
                value={apiKey}
                onChange={(e) => setApiKey(e.target.value)}
                autoComplete="off"
                placeholder="paste your secret key"
              />
              <button className={s.reveal} type="button" onClick={() => setShowKey((v) => !v)}>
                {showKey ? 'Hide' : 'Show'}
              </button>
            </div>
            <span className={s.hint}>
              Pasted keys are masked. Leave blank for keyless local endpoints (e.g. Ollama).
            </span>
          </div>

          <div className={s.toggleRow}>
            <label htmlFor="a-default">Set as default provider for new chats</label>
            <label className={s.toggle}>
              <input
                id="a-default"
                type="checkbox"
                checked={makeDefault}
                onChange={(e) => setMakeDefault(e.target.checked)}
              />
              <span className={s.track} />
              <span className={s.thumb} />
            </label>
          </div>

          <div className={s.secureNote}>
            <span className={s.lock}>🔒</span>
            <span>
              Stored encrypted in your OS keychain on this device only — never written to disk in
              plaintext, never hardcoded, never synced.
            </span>
          </div>

          <div className={s.dialogFoot}>
            <span className={s.grow} />
            <Button variant="ghost" onClick={onClose}>
              Cancel
            </Button>
            <Button onClick={onClose}>Test &amp; Save</Button>
          </div>
        </div>
      </div>
    </>
  );
}
