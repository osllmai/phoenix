import p from '../page.module.css';
import { TELEMETRY_HELP, TELEMETRY_LABEL } from './data';
import s from './result.module.css';
import StepIndicator from './StepIndicator';
import TelemetryToggle from './Switch';

const CHIPS = ['On-device inference', 'Documents via Docling', 'Local API server', 'No telemetry'];

type Props = {
  telemetry: boolean;
  onToggle: () => void;
  onBack: () => void;
  onEnter: () => void;
};

export default function ReadyStep({ telemetry, onToggle, onBack, onEnter }: Props) {
  return (
    <div className={p.card}>
      <StepIndicator
        label="All set"
        dots={[
          { content: '✓', state: 'done' },
          { content: '✓', state: 'done' },
          { content: '3', state: 'active' },
        ]}
      />
      <div className={p.body}>
        <div className={s.readyHero}>
          <div className={s.big}>🔥</div>
          <h2>You&apos;re all set</h2>
          <p>Phoenix is ready. Your models run entirely on this machine — nothing leaves.</p>
          <div className={s.chips}>
            {CHIPS.map((c) => (
              <span key={c} className={s.chip}>
                {c}
              </span>
            ))}
          </div>
        </div>
        <div className={s.readyModel}>
          <span className={s.ico}>🦙</span>
          <div>
            <div className={s.lbl}>Llama 3.2 3B Instruct</div>
            <div className={s.sub}>2.0 GB · Q4_K_M · installing on-device</div>
          </div>
          <span className={s.ok}>In progress</span>
        </div>
        <TelemetryToggle
          on={telemetry}
          onToggle={onToggle}
          label={TELEMETRY_LABEL}
          help={TELEMETRY_HELP}
        />
        <p className={s.privacySubline}>
          🔒 Inference runs entirely on-device · conversations stay in local SQLite · no network
          required.
        </p>
      </div>
      <div className={p.footer}>
        <button type="button" className={p.btnBack} onClick={onBack}>
          ← Back
        </button>
        <span className={p.grow} />
        <button type="button" className={p.btnNext} onClick={onEnter}>
          Enter Phoenix →
        </button>
      </div>
    </div>
  );
}
