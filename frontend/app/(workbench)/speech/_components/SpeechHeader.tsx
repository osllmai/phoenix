'use client';

import { PageHeader } from '@/app/components/ui';

import { LANGUAGES, WHISPER_MODELS } from './sampleData';
import s from '../page.module.css';

const TOGGLES = ['Timestamps', 'Speaker hints', 'Translate → EN'] as const;
type Toggle = (typeof TOGGLES)[number];

export default function SpeechHeader({
  model,
  onModel,
  language,
  onLanguage,
  active,
  onToggle,
}: {
  model: string;
  onModel: (v: string) => void;
  language: string;
  onLanguage: (v: string) => void;
  active: Record<Toggle, boolean>;
  onToggle: (t: Toggle) => void;
}) {
  return (
    <PageHeader title="🎙 Speech">
      <div className={s.sep} />
      <div className={s.picker}>
        <label>Model</label>
        <select value={model} onChange={(e) => onModel(e.target.value)}>
          {WHISPER_MODELS.map((m) => (
            <option key={m.name} value={m.name}>
              {m.label}
            </option>
          ))}
        </select>
      </div>
      <div className={s.picker}>
        <label>Language</label>
        <select value={language} onChange={(e) => onLanguage(e.target.value)}>
          {LANGUAGES.map((l) => (
            <option key={l} value={l}>
              {l}
            </option>
          ))}
        </select>
      </div>
      <div className={s.sep} />
      {TOGGLES.map((t) => (
        <button
          key={t}
          type="button"
          className={`${s.toggle} ${active[t] ? s.on : ''}`}
          onClick={() => onToggle(t)}
        >
          {t}
        </button>
      ))}
    </PageHeader>
  );
}
