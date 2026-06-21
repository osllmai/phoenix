'use client';

import { useState } from 'react';

import s from './composer.module.css';
import { RAG_SOURCES } from './data';

function RagTools() {
  const [rag, setRag] = useState(true);
  const [pop, setPop] = useState(false);
  return (
    <div className={s.comptools}>
      <button className={`${s.ctoggle} ${rag ? s.ctoggleOn : ''}`} onClick={() => setRag((v) => !v)}>
        📄 Chat with documents
      </button>
      <span className={s.ragsrc}>
        Grounded in <b>product-roadmap-2026.docx</b>, llama-3-technical-report.pdf ·{' '}
        <span className={s.ragsrcWrap}>
          <button className={s.ragsrcLink} onClick={() => setPop((v) => !v)}>
            change sources
          </button>
          {pop && (
            <div className={s.ragPop}>
              <div className={s.rpHead}>Ground in documents</div>
              {RAG_SOURCES.map((d) => (
                <label key={d.name} className={s.rpItem}>
                  <input type="checkbox" defaultChecked={d.on} /> {d.name}
                </label>
              ))}
              <div className={s.rpFoot}>
                <a href="#docs">Manage all docs…</a>
                <button onClick={() => setPop(false)}>Done</button>
              </div>
            </div>
          )}
        </span>
      </span>
    </div>
  );
}

export default function Composer({
  placeholder = 'Message Phoenix…',
  value = '',
  disabled = false,
  generating = false,
  rag = false,
  hintLeft,
  hintRight = '0 / 4096 tokens',
  hintError = false,
}: {
  placeholder?: string;
  value?: string;
  disabled?: boolean;
  generating?: boolean;
  rag?: boolean;
  hintLeft?: string;
  hintRight?: string;
  hintError?: boolean;
}) {
  return (
    <div className={s.composer}>
      {rag && <RagTools />}
      {!rag && !disabled && (
        <div className={s.comptools}>
          <button className={s.ctoggle}>📄 Chat with documents</button>
        </div>
      )}
      <div className={`${s.inputwrap} ${disabled ? s.dim : ''}`}>
        {!disabled && (
          <button className={s.iconbtn} title="Attach file">
            📎
          </button>
        )}
        <textarea rows={1} placeholder={placeholder} defaultValue={value} disabled={disabled} />
        {!disabled && (
          <button className={s.iconbtn} title="Voice (Whisper)">
            🎙
          </button>
        )}
        {generating ? (
          <button className={`${s.send} ${s.sendStop}`} title="Stop generating">
            ■
          </button>
        ) : (
          <button className={s.send} title="Send" disabled={disabled}>
            ➤
          </button>
        )}
      </div>
      <div className={s.hint}>
        <span className={hintError ? s.errHint : ''}>
          {hintLeft ?? 'Enter to send · Shift+Enter for newline'}
        </span>
        <span>{hintRight}</span>
      </div>
    </div>
  );
}
