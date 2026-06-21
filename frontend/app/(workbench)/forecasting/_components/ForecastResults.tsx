import ForecastChart from './ForecastChart';
import { SAMPLE_HISTORY, SAMPLE_P50, SAMPLE_ROWS, SAMPLE_STATS } from './sampleData';
import s from '../page.module.css';

export default function ForecastResults() {
  return (
    <section className={s.output}>
      <div className={s.outputTop}>
        <h2 className={s.outputTitle}>AAPL · 1D — 24-step forecast</h2>
        <button type="button" className={s.act}>
          📋 Copy values
        </button>
        <button type="button" className={s.act}>
          ⤓ Export CSV
        </button>
        <button type="button" className={s.act}>
          📄 Send to Documents
        </button>
        <button type="button" className={`${s.act} ${s.actPrimary}`}>
          💬 Explain in Chat
        </button>
      </div>
      <div className={s.scroll}>
        <ForecastChart hist={SAMPLE_HISTORY} p50={SAMPLE_P50} />

        <div className={s.statgrid}>
          {SAMPLE_STATS.map((stat) => (
            <div key={stat.k} className={s.stat}>
              <div className={s.statK}>{stat.k}</div>
              <div className={s.statV}>
                {stat.v} {stat.small && <small>{stat.small}</small>}
              </div>
            </div>
          ))}
        </div>

        <table className={s.tbl}>
          <thead>
            <tr>
              <th>Step</th>
              <th>P10</th>
              <th>P50</th>
              <th>P90</th>
            </tr>
          </thead>
          <tbody>
            {SAMPLE_ROWS.map((row) => (
              <tr key={row.step}>
                <td>{row.step}</td>
                <td>{row.p10.toFixed(1)}</td>
                <td>{row.p50.toFixed(1)}</td>
                <td>{row.p90.toFixed(1)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </section>
  );
}
