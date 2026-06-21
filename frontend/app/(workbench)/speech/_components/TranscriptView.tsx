'use client';

import { useState } from 'react';

import { EXPORT_FORMATS, SAMPLE_SEGMENTS } from './sampleData';
import s from '../page.module.css';

export default function TranscriptView() {
  const [at, setAt] = useState('00:29');
  const [playing, setPlaying] = useState(false);

  return (
    <div className={s.output}>
      <div className={s.outputTop}>
        <h2 className={s.outputTitle}>
          Transcript <span className={s.editHint}>· editable · click a timestamp to seek</span>
        </h2>
        <button className={s.act} type="button">📋 Copy</button>
        <div className={s.menu}>
          <button className={s.act} type="button">⤓ Export ▾</button>
          <div className={s.pop}>
            {EXPORT_FORMATS.map((f) => (
              <button key={f} type="button">{f}</button>
            ))}
          </div>
        </div>
        <button className={s.act} type="button">📄 Send to Documents</button>
        <button className={`${s.act} ${s.primary}`} type="button">💬 Send to Chat</button>
      </div>

      <div className={s.scroll}>
        {SAMPLE_SEGMENTS.map((seg) => (
          <div className={s.segment} key={`${seg.start}-${seg.end}`}>
            <span className={s.segMeta}>
              <span
                className={s.segTime}
                role="button"
                tabIndex={0}
                onClick={() => {
                  setAt(seg.start);
                  setPlaying(true);
                }}
              >
                {seg.start} → {seg.end}
              </span>
              <br />
              {seg.speaker && <span className={s.segSpk}>{seg.speaker}</span>}
            </span>
            <span className={s.segText} contentEditable suppressContentEditableWarning title="Click to edit">
              {seg.text}
            </span>
          </div>
        ))}
      </div>

      <div className={s.player}>
        <button className={s.pp} type="button" title="Play / pause" onClick={() => setPlaying((p) => !p)}>
          {playing ? '⏸' : '▶'}
        </button>
        <span className={s.ptime}>{at}</span>
        <div className={s.seek}>
          <div className={s.seekAt} />
        </div>
        <span className={s.ptime}>01:47</span>
      </div>
    </div>
  );
}
