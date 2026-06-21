import { PLAN_STEPS, SAMPLE_GOAL, type PlanStep } from './sampleData';
import s from '../page.module.css';

const STEP_CLASS: Record<PlanStep['status'], string> = {
  done: s.stepDone,
  run: s.stepRun,
  pending: s.stepPending,
};

export default function Conductor() {
  return (
    <div className={s.conductor}>
      <div className={s.condHead}>
        <h2 className={s.condTitle}>Conductor</h2>
        <div className={s.condSub}>local LLM · plans &amp; delegates · routes, never edits</div>
      </div>

      <div className={s.condGoal}>
        <span className={s.condGoalLbl}>Goal</span>
        {SAMPLE_GOAL}
      </div>

      <div className={s.seclbl}>Plan · timeline</div>
      <div className={s.timeline}>
        {PLAN_STEPS.map((step) => (
          <div key={step.title} className={`${s.step} ${STEP_CLASS[step.status]}`}>
            <span className={s.marker}>{step.marker}</span>
            <div>
              <div className={s.stitle}>{step.title}</div>
              <div className={s.smeta}>{step.meta}</div>
            </div>
          </div>
        ))}
      </div>

      <div className={s.condFoot}>
        <div className={s.patternPill}>
          pattern: <b>PIPELINE</b> · plan→impl→test→review
        </div>
        <button className={s.merge} type="button">
          merge ▸ diff
        </button>
      </div>
    </div>
  );
}
