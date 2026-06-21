import s from '../page.module.css';
import { LOG_ROWS, type LogStatus } from './sampleData';

function statusClass(status: LogStatus) {
  if (status === 'err') return s.err;
  if (status === 'warn') return s.warn;
  return s.ok;
}

export default function RequestLog() {
  return (
    <div className={s.card}>
      <div className={s.cardHead}>
        <h3>Request log</h3>
        <span className={s.live}>
          <span className={s.liveDot} />
          live
        </span>
        <span className={s.grow} />
        <button className={s.btnSm} type="button">
          Pause
        </button>
        <button className={s.btnSm} type="button">
          Export
        </button>
      </div>
      <div className={`${s.cardBody} ${s.cardBodyFlush}`}>
        <table className={s.table}>
          <thead>
            <tr>
              <th>Time</th>
              <th>Method</th>
              <th>Path</th>
              <th>Model</th>
              <th>Status</th>
              <th>Latency</th>
            </tr>
          </thead>
          <tbody>
            {LOG_ROWS.map((r, i) => (
              <tr key={`${r.time}-${i}`}>
                <td className={s.ts}>{r.time}</td>
                <td>
                  <span className={`${s.method} ${r.method === 'GET' ? s.get : s.post}`}>{r.method}</span>
                </td>
                <td className={s.path}>{r.path}</td>
                <td>{r.model}</td>
                <td>
                  <span className={`${s.scode} ${statusClass(r.status)}`}>{r.code}</span>
                </td>
                <td className={s.lat}>{r.latency}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
