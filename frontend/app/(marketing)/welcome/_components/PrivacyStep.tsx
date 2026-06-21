import p from '../page.module.css';
import { PRIVACY_POINTS, TELEMETRY_HELP, TELEMETRY_LABEL } from './data';
import StepIndicator from './StepIndicator';
import s from './steps.module.css';
import TelemetryToggle from './Switch';

type Props = {
  telemetry: boolean;
  onToggle: () => void;
  onBack: () => void;
  onContinue: () => void;
};

export default function PrivacyStep({ telemetry, onToggle, onBack, onContinue }: Props) {
  return (
    <div className={p.card}>
      <StepIndicator
        label="Privacy"
        dots={[
          { content: '✓', state: 'done' },
          { content: '✓', state: 'done' },
          { content: '3', state: 'active' },
          { content: '4', state: 'todo' },
        ]}
      />
      <div className={p.body}>
        <div className={p.hero}>
          <h1 className={p.sm}>Your data stays on-device</h1>
        </div>
        <div className={s.privacyPoints}>
          {PRIVACY_POINTS.map((pt) => (
            <div key={pt.title} className={s.ppoint}>
              <span className={s.picon}>{pt.icon}</span>
              <div>
                <div className={s.ptitle}>{pt.title}</div>
                <div className={s.pdesc}>{pt.desc}</div>
              </div>
            </div>
          ))}
        </div>
        <TelemetryToggle
          on={telemetry}
          onToggle={onToggle}
          label={TELEMETRY_LABEL}
          help={TELEMETRY_HELP}
        />
      </div>
      <div className={p.footer}>
        <button type="button" className={p.btnBack} onClick={onBack}>
          ← Back
        </button>
        <span className={p.grow} />
        <button type="button" className={p.btnNext} onClick={onContinue}>
          Continue →
        </button>
      </div>
    </div>
  );
}
