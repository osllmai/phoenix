'use client';

import { SAMPLE_CONNECTORS, SAMPLE_SERIES } from './sampleData';
import s from '../page.module.css';

export default function ForecastControls({
  source,
  onSource,
  selected,
  onSelect,
  onRun,
}: {
  source: string;
  onSource: (id: string) => void;
  selected: string;
  onSelect: (id: string) => void;
  onRun: () => void;
}) {
  return (
    <aside className={s.ctrl}>
      <div className={s.csec}>
        <div className={s.clabel}>Data source</div>
        <div className={s.sources}>
          {SAMPLE_CONNECTORS.map((c) => (
            <button
              key={c.id}
              type="button"
              className={`${s.src} ${source === c.id ? s.srcOn : ''}`}
              onClick={() => onSource(c.id)}
            >
              {c.connected && <span className={s.ok}>●</span>} {c.label}
            </button>
          ))}
        </div>
        <div className={s.srcnote}>
          IBKR connected · 3 symbols · live OHLCV · <a className={s.link}>manage connectors</a>
        </div>
      </div>

      <div className={s.csec}>
        <div className={s.clabel}>Series</div>
        <div className={s.serieslist}>
          {SAMPLE_SERIES.map((series) => (
            <button
              key={series.id}
              type="button"
              className={`${s.series} ${selected === series.id ? s.seriesSel : ''}`}
              onClick={() => onSelect(series.id)}
            >
              <div>
                <div className={s.sname}>{series.name}</div>
                <div className={s.smeta}>{series.meta}</div>
              </div>
              <span className={s.grow} />
              {series.active && <span className={`${s.chip} ${s.green}`}>active</span>}
            </button>
          ))}
        </div>
        <div className={`${s.dropzone} ${s.dropTop}`}>
          <span className={s.dropIco}>📈</span>
          Drop a CSV / Parquet — or pull from a broker
          <div className={s.dropSub}>timestamp + value · OHLCV · optional covariates</div>
        </div>
      </div>

      <div className={s.csec}>
        <div className={s.clabel}>Forecast settings</div>
        <div className={s.field}>
          <label>Frequency</label>
          <select defaultValue="W">
            <option value="W">Weekly (W)</option>
            <option value="D">Daily (D)</option>
            <option value="H">Hourly (H)</option>
            <option value="M">Monthly (M)</option>
          </select>
        </div>
        <div className={s.fieldRow2}>
          <div>
            <label>Context</label>
            <input defaultValue="512" />
          </div>
          <div>
            <label>Horizon</label>
            <input defaultValue="24" />
          </div>
        </div>
        <div className={s.field}>
          <label>Quantiles</label>
          <select defaultValue="10/50/90">
            <option value="10/50/90">10 / 50 / 90</option>
            <option value="5/50/95">5 / 50 / 95</option>
            <option value="deciles">Deciles (10–90)</option>
          </select>
        </div>
        <button type="button" className={s.run} onClick={onRun}>
          ▶ Run forecast
        </button>
      </div>

      <div className={s.csec}>
        <div className={s.clabel}>Last run</div>
        <div className={s.chips}>
          <span className={`${s.chip} ${s.amber}`}>on-device</span>
          <span className={s.chip}>zero-shot</span>
          <span className={s.chip}>1.8s · CPU</span>
          <span className={s.chip}>512 → 24</span>
        </div>
        <div className={s.note}>
          🔒 TimesFM weights stored locally under <code>~/phoenix/models/timesfm/</code>. Inference
          is a Celery backend job; the chat engine (llama.cpp) is untouched.
        </div>
      </div>
    </aside>
  );
}
