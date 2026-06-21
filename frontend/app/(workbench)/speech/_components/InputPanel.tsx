'use client';

import { ACCEPTED_FORMATS, SAMPLE_SESSION, type SpeechState } from './sampleData';
import Waveform, { type WaveMode } from './Waveform';
import s from '../page.module.css';

const REC: Record<
  SpeechState,
  { cls: string; icon: string; label: string; sub: string; labelTone?: boolean }
> = {
  success: { cls: '', icon: '🎙', label: 'Record', sub: 'Click or press Space to capture' },
  empty: { cls: '', icon: '🎙', label: 'Record', sub: 'Click or press Space to capture' },
  'first-run': { cls: s.off, icon: '🎙', label: 'Record', sub: 'Download a model first' },
  loading: { cls: s.busy, icon: '⏹', label: 'Transcribing…', sub: '00:42 of 01:30 processed' },
  error: { cls: s.bad, icon: '🎙', label: 'Record', sub: 'Try again with a supported format' },
  denied: { cls: s.bad, icon: '🚫', label: 'Mic access denied', sub: 'Grant permission in system settings', labelTone: true },
};

const WAVE: Partial<Record<SpeechState, WaveMode>> = {
  success: 'static',
  empty: 'flat',
  loading: 'live',
};

export default function InputPanel({
  state,
  onRecord,
  children,
}: {
  state: SpeechState;
  onRecord?: () => void;
  children?: React.ReactNode;
}) {
  const rec = REC[state];
  const wave = WAVE[state];
  const dropDisabled = state === 'first-run';
  const dropBad = state === 'error';

  return (
    <div className={s.ctrl}>
      <div className={s.csec}>
        <div className={s.clabel}>Input</div>
        <button
          type="button"
          className={`${s.recBtn} ${rec.cls}`}
          onClick={state === 'success' || state === 'empty' ? onRecord : undefined}
        >
          <div className={s.recIcon}>{rec.icon}</div>
          <div className={`${s.recLabel} ${rec.labelTone ? s.recLabelBad : ''}`}>
            {rec.label}
            {(state === 'success' || state === 'empty') && <span className={s.kbd}>Space</span>}
          </div>
          <div className={`${s.recSub} ${state === 'loading' ? s.recSubWarn : ''}`}>{rec.sub}</div>
        </button>
        {wave && <Waveform mode={wave} />}
      </div>

      <div className={s.csec}>
        <div className={s.clabel}>{state === 'denied' ? 'Upload still works' : 'Or upload a file'}</div>
        <div className={`${s.dropzone} ${dropDisabled ? s.off : ''} ${dropBad ? s.bad : ''}`}>
          <span className={s.dropIco}>📁</span>
          {dropBad ? 'Drop a supported file' : state === 'denied' ? 'Drop a file to transcribe instead' : 'Drop audio or video here'}
          <div className={`${s.dropSub} ${dropBad ? s.dropSubBad : ''}`}>
            {dropBad ? 'Last file was rejected' : ACCEPTED_FORMATS}
          </div>
        </div>
      </div>

      {state === 'success' && (
        <div className={s.csec}>
          <div className={s.clabel}>Session</div>
          <div className={s.chips}>
            {SAMPLE_SESSION.map((c) => (
              <span key={c.label} className={`${s.chip} ${c.tone ? s[c.tone] : ''}`}>
                {c.label}
              </span>
            ))}
          </div>
        </div>
      )}

      {children}
    </div>
  );
}
