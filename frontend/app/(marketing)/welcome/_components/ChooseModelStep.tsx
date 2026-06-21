import p from '../page.module.css';
import { MODELS } from './data';
import StepIndicator from './StepIndicator';
import s from './steps.module.css';

type Props = {
  selected: string;
  onSelect: (id: string) => void;
  onBack: () => void;
  onViewDownload: () => void;
  onEnter: () => void;
};

export default function ChooseModelStep({
  selected,
  onSelect,
  onBack,
  onViewDownload,
  onEnter,
}: Props) {
  return (
    <div className={p.card}>
      <StepIndicator
        label="Choose a model"
        dots={[
          { content: '✓', state: 'done' },
          { content: '2', state: 'active' },
          { content: '3', state: 'todo' },
        ]}
      />
      <div className={p.body}>
        <div className={p.hero}>
          <h1 className={p.sm}>Pick your first model</h1>
        </div>
        <p className={p.leadSm}>Downloaded once and kept on disk — runs fully on-device.</p>
        <div className={s.modelCards}>
          {MODELS.map((m) => (
            <button
              type="button"
              key={m.id}
              className={`${s.mcard} ${selected === m.id ? s.sel : ''}`}
              aria-pressed={selected === m.id}
              onClick={() => onSelect(m.id)}
            >
              <span className={s.ico}>{m.ico}</span>
              <div>
                <div className={s.label}>{m.label}</div>
                <div className={s.sub}>{m.sub}</div>
              </div>
              <div className={s.specs}>
                <span className={s.spec}>{m.size}</span>
                <span className={s.spec}>{m.quant}</span>
              </div>
            </button>
          ))}
        </div>
        <div className={s.sourceRow}>
          <span className={s.source}>📁 Or add a local .gguf file</span>
          <span className={s.source}>🤗 Browse the Hugging Face Hub</span>
        </div>
        <p className={p.footNoteCenter}>
          The model installs in the background — enter Phoenix now and keep working while it
          finishes.
        </p>
      </div>
      <div className={p.footer}>
        <button type="button" className={p.btnBack} onClick={onBack}>
          ← Back
        </button>
        <span className={p.grow} />
        <button type="button" className={p.btnGhost} onClick={onViewDownload}>
          View download
        </button>
        <button type="button" className={p.btnNext} onClick={onEnter}>
          Enter Phoenix →
        </button>
      </div>
    </div>
  );
}
