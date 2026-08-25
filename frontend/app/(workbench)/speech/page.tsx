'use client';

import { useState } from 'react';

import { MockStateSwitcher } from '@/app/components/dev/MockStateSwitcher';
import { Button, EmptyState, ErrorState } from '@/app/components/ui';

import FirstRunView from './_components/FirstRunView';
import InputPanel from './_components/InputPanel';
import LoadingView from './_components/LoadingView';
import SpeechHeader from './_components/SpeechHeader';
import TranscriptView from './_components/TranscriptView';
import { type SpeechState } from './_components/sampleData';
import s from './page.module.css';

const STATES: SpeechState[] = ['success', 'empty', 'first-run', 'loading', 'error', 'denied'];

const DISABLED_ACTIONS = (
  <>
    <button className={s.act} type="button" disabled>📋 Copy</button>
    <button className={s.act} type="button" disabled>⤓ Export</button>
    <button className={s.act} type="button" disabled>📄 Send to Documents</button>
    <button className={`${s.act} ${s.primary}`} type="button" disabled>💬 Send to Chat</button>
  </>
);

export default function SpeechPage() {
  const [state, setState] = useState<SpeechState>('success');
  const [model, setModel] = useState('small');
  const [language, setLanguage] = useState('Auto-detect');
  const [toggles, setToggles] = useState({ Timestamps: true, 'Speaker hints': true, 'Translate → EN': false });

  const toggle = (t: keyof typeof toggles) => setToggles((p) => ({ ...p, [t]: !p[t] }));

  return (
    <>
      <MockStateSwitcher
        states={STATES}
        value={state}
        onChange={setState}
        className={s.switcher}
        activeClassName={s.switchOn}
      />

      <SpeechHeader
        model={model}
        onModel={setModel}
        language={language}
        onLanguage={setLanguage}
        active={toggles}
        onToggle={toggle}
      />

      <div className={s.jobbar}>
        <span className={s.jobDot} /> whisper.cpp ready · ggml weights loaded
        <span className={s.qpill}>small · CPU + Metal</span>
        <span className={s.grow} />
        <span>ASR runs on-device · long files queue as a Docling/Celery backend job</span>
      </div>

      <div className={s.body}>
        {state === 'success' && (
          <div className={s.split}>
            <InputPanel state="success" onRecord={() => setState('loading')} />
            <TranscriptView />
          </div>
        )}

        {state === 'loading' && <LoadingView onCancel={() => setState('empty')} />}

        {state === 'first-run' && <FirstRunView />}

        {state === 'empty' && (
          <div className={s.split}>
            <InputPanel state="empty" onRecord={() => setState('loading')} />
            <div className={s.output}>
              <div className={s.outputTop}>
                <h2 className={s.outputTitle}>Transcript</h2>
                {DISABLED_ACTIONS}
              </div>
              <EmptyState
                icon="🎙"
                title="No transcriptions yet"
                description="Record from your microphone or drop an audio/video file to transcribe on-device with Whisper."
              />
            </div>
          </div>
        )}

        {state === 'error' && (
          <div className={s.split}>
            <InputPanel state="error" />
            <div className={s.output}>
              <div className={s.outputTop}>
                <h2 className={s.outputTitle}>Transcript</h2>
              </div>
              <ErrorState
                title="Transcription failed"
                heading="The engine could not decode the audio"
                message="Usually an unsupported codec or a corrupted file. Supported: WAV (PCM) · MP3 · M4A (AAC) · FLAC · OGG · MP4."
                actions={
                  <>
                    <Button onClick={() => setState('loading')}>↺ Retry</Button>
                    <Button variant="ghost">Upload different file</Button>
                  </>
                }
                sub={<code>whisper_full: failed to open audio file (error -1)</code>}
              />
            </div>
          </div>
        )}

        {state === 'denied' && (
          <div className={s.split}>
            <InputPanel state="denied" />
            <div className={s.output}>
              <ErrorState
                icon="🔒"
                variant="warning"
                title="Microphone access denied"
                heading="Grant microphone permission"
                message="Phoenix needs microphone permission to record. Grant access in your system settings, or upload a file instead."
                actions={
                  <>
                    <Button>Open system settings</Button>
                    <Button variant="ghost">Upload a file</Button>
                  </>
                }
                sub="macOS: System Settings → Privacy & Security → Microphone → enable Phoenix."
              />
            </div>
          </div>
        )}
      </div>
    </>
  );
}
