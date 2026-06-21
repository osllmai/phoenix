'use client';

import { Button, CenterState } from '@/app/components/ui';

import InputPanel from './InputPanel';
import { DOWNLOAD_CARDS } from './sampleData';
import s from '../page.module.css';

export default function FirstRunView() {
  return (
    <div className={s.split}>
      <InputPanel state="first-run" />
      <div className={s.output}>
        <CenterState
          icon="📥"
          title="Record or drop a file to start"
          description="Phoenix runs speech recognition fully on-device with whisper.cpp (ggml). Pick a model size — nothing is sent to the cloud."
        >
          <div className={s.modelList}>
            {DOWNLOAD_CARDS.map((c) => (
              <div className={s.modelCard} key={c.name}>
                <div>
                  <div className={s.mcName}>{c.name}</div>
                  <div className={s.mcMeta}>{c.meta}</div>
                </div>
                <Button variant={c.recommended ? 'cta' : 'ghost'} className={s.mcDl}>
                  ⬇ Download
                </Button>
              </div>
            ))}
          </div>
          <div className={s.note}>
            🔒 Supported formats: WAV · MP3 · M4A · MP4. Weights are stored locally under{' '}
            <code>~/phoenix/models/whisper/</code>.
          </div>
        </CenterState>
      </div>
    </div>
  );
}
