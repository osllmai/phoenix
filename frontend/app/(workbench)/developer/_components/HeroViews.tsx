'use client';

import { useState } from 'react';

import { Button, CenterState, ErrorState } from '@/app/components/ui';

import s from '../page.module.css';
import { SERVER } from './sampleData';

export function FirstRunView({ onStart }: { onStart: () => void }) {
  const [port, setPort] = useState(SERVER.port);
  const info = [
    { lbl: 'Bind', val: SERVER.bind },
    { lbl: 'Port', val: SERVER.port },
    { lbl: 'Auth', val: 'API key (Bearer token)' },
    { lbl: 'Default', val: SERVER.defaultModel },
  ];
  return (
    <CenterState
      icon="🖥️"
      title="Serve local models over an OpenAI- & Anthropic-compatible API"
      description={
        <>
          <span className={s.inlineCode}>phoenix_server</span> exposes your on-device engine over HTTP
          so external tools — Claude Code, Python scripts, OpenAI SDKs — can use local models without
          leaving your machine.
        </>
      }
    >
      <div className={s.infoList}>
        {info.map((r) => (
          <div className={s.infoRow} key={r.lbl}>
            <span className={s.infoLbl}>{r.lbl}</span>
            <span className={s.infoVal}>{r.val}</span>
          </div>
        ))}
      </div>
      <div className={s.portRow}>
        <label className={s.portLabel}>
          Port
          <input
            className={`${s.selInline} ${s.portInput}`}
            value={port}
            onChange={(e) => setPort(e.target.value)}
          />
        </label>
        <Button onClick={onStart}>Start on this port</Button>
      </div>
    </CenterState>
  );
}

export function DeniedView() {
  return (
    <ErrorState
      icon="🚫"
      title="Unauthorized request rejected"
      heading="401 — authentication_error"
      message={
        <>
          A client called the server with a missing, invalid, or revoked API key. The gateway never
          reaches the model — it returns <span className={s.inlineCode}>401</span> before inference.
          Issue or copy a valid key, then set it as the Bearer token.
        </>
      }
      actions={
        <>
          <Button>＋ Create key</Button>
          <Button variant="ghost">View API keys</Button>
        </>
      }
      sub={
        <pre className={s.httpBlock}>
          <span className={s.headerLine}>{'$ curl -H "Authorization: Bearer phx_live_revoked" \\'}</span>
          {'\n'}
          <span className={s.headerLine}>{'    '}http://127.0.0.1:8645/v1/messages</span>
          {'\n\n'}
          <span className={s.statusLine}>HTTP/1.1 401 Unauthorized</span>
          {'\n'}
          <span className={s.headerLine}>content-type: application/json</span>
          {'\n'}
          <span className={s.headerLine}>x-request-id: req_01JV3K8N2TQ…</span>
          {'\n\n'}
          <span className={s.bodyLine}>{'{ "error": { "type": "authentication_error",'}</span>
          {'\n'}
          <span className={s.bodyLine}>{'    "message": "API key is invalid or has been revoked." } }'}</span>
        </pre>
      }
    />
  );
}
