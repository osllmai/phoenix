import type { Evaluator } from './data';
import s from '../page.module.css';

export default function EvaluatorCard({
  evaluator,
  onToggle,
}: {
  evaluator: Evaluator;
  onToggle: (id: string) => void;
}) {
  const { id, icon, name, badge, description, metrics, judges, enabled } = evaluator;
  return (
    <div className={s.evCard}>
      <div className={s.evHead}>
        <span className={s.evIcon}>{icon}</span>
        <h3 className={s.evName}>{name}</h3>
        <span className={`${s.badge} ${badge.tone === 'first' ? s.bFirst : s.bOss}`}>
          {badge.label}
        </span>
        <span className={s.grow} />
        <button
          className={`${s.toggle} ${enabled ? s.toggleOn : ''}`}
          onClick={() => onToggle(id)}
          type="button"
        >
          <span className={s.pip} /> {enabled ? 'Enabled' : 'Disabled'}
        </button>
      </div>

      <p className={s.evDesc}>{description}</p>

      <div className={s.evMetrics}>
        {metrics.map((mtc) => (
          <span key={mtc} className={`${s.badge} ${s.bMetric}`}>
            {mtc}
          </span>
        ))}
      </div>

      <div className={s.evFoot}>
        <span className={s.k}>judge model</span>
        <select className={s.selInline} defaultValue={judges[0]}>
          {judges.map((j) => (
            <option key={j}>{j}</option>
          ))}
        </select>
        <span className={s.grow} />
        <span className={s.evLink}>Use as gate in Flows →</span>
        <span className={s.evLink}>Use as judge in Maestro →</span>
      </div>
    </div>
  );
}
