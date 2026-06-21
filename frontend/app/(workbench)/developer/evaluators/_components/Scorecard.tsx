import type { Scorecard as ScorecardData, Meter } from './data';
import s from '../page.module.css';

function MeterRow({ meter }: { meter: Meter }) {
  const fillClass =
    meter.tone === 'warn' ? s.fillWarn : meter.tone === 'fail' ? s.fillFail : '';
  const pfClass = meter.verdict === 'PASS' ? s.pfPass : s.pfFail;
  return (
    <div className={s.meter}>
      <span className={s.mlbl}>{meter.label}</span>
      <span className={s.track}>
        <span className={`${s.fill} ${fillClass}`} style={{ width: `${meter.fill}%` }} />
      </span>
      <span className={s.val}>{meter.display}</span>
      <span className={s.thr}>
        <span className={`${s.pf} ${pfClass}`}>{meter.verdict}</span>
        <span className={s.op}>{meter.op}</span>
        <input className={s.thrInput} defaultValue={meter.threshold} />
      </span>
    </div>
  );
}

export default function Scorecard({ data }: { data: ScorecardData }) {
  return (
    <div className={s.scorecard}>
      <div className={s.scHead}>
        <strong>{data.candidate}</strong>
        <span className={s.run}>{data.run}</span>
        <span className={s.grow} />
        <span className={`${s.verdict} ${data.verdict.pass ? '' : s.verdictFail}`}>
          {data.verdict.label}
        </span>
      </div>

      {data.meters.map((m) => (
        <MeterRow key={m.label} meter={m} />
      ))}

      <p className={s.scNote}>{data.note}</p>
    </div>
  );
}
