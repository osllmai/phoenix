import type { PlanStep } from './sampleData';
import s from '../page.module.css';

export default function PlanTimeline({ steps }: { steps: PlanStep[] }) {
  return (
    <div className={s.stepper}>
      {steps.map((step) => (
        <div className={s.step} key={step.label}>
          <div className={`${s.stepDot} ${s[step.status]}`}>
            {step.status === 'active' ? <span className={s.spinner} /> : step.badge}
          </div>
          <div>
            <div className={s.stlabel}>{step.label}</div>
            <div className={s.stmeta}>{step.meta}</div>
          </div>
        </div>
      ))}
    </div>
  );
}
