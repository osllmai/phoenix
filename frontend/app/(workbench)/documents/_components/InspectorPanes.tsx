import {
  CHUNKS,
  ENRICHMENTS,
  EXTRACT_FIELDS,
  FIGURES,
  INSIGHT_METERS,
  TABLE_ROWS,
} from './inspectorData';
import s from '../page.module.css';

export function MarkdownPane() {
  return (
    <div className={s.md}>
      <h2>Llama 3 Technical Report</h2>
      <p>
        We introduce a new set of foundation models that natively support multilinguality, coding,
        reasoning, and tool use…
      </p>
      <h3>3.1 Pre-training Data</h3>
      <p>
        The training corpus is assembled from a variety of sources. Reading order and layout are
        preserved by the Docling layout model.
      </p>
      <pre>{`def scaled_dot_product_attention(q, k, v):
    return softmax(q @ k.T / sqrt(d_k)) @ v`}</pre>
    </div>
  );
}

export function TablesPane() {
  return (
    <>
      <div className={s.rowInline}>
        <span className={s.dim}>2 tables recognized via TableFormer</span>
        <span className={s.grow} />
        <button className={s.miniact}>Export CSV</button>
        <button className={s.miniact}>Export HTML</button>
      </div>
      <table className={s.tbl}>
        <thead>
          <tr>
            <th>Model</th>
            <th>Params</th>
            <th>MMLU</th>
            <th>HumanEval</th>
          </tr>
        </thead>
        <tbody>
          {TABLE_ROWS.map((r) => (
            <tr key={r[0]}>
              {r.map((c, i) => (
                <td key={i}>{c}</td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </>
  );
}

export function FiguresPane() {
  return (
    <>
      <div className={s.rowInline}>
        <span className={s.dim}>12 figures · auto-captioned (picture description)</span>
        <span className={s.grow} />
        <button className={s.miniact}>Export figures</button>
      </div>
      <div className={s.figgrid}>
        {FIGURES.map((f) => (
          <div key={f.caption} className={s.figcard}>
            <div className={s.figthumb}>{f.thumb}</div>
            <div className={s.figcap}>
              <span className={s.figlbl}>{f.label}</span> — {f.caption}
            </div>
          </div>
        ))}
      </div>
    </>
  );
}

export function ChunksPane() {
  return (
    <>
      <div className={s.rowInline}>
        <span className={`${s.toggle} ${s.toggleOn}`}>Hybrid</span>
        <span className={s.toggle}>Hierarchical</span>
        <span className={s.toggle}>Line-based</span>
        <span className={s.grow} />
        <span className={`${s.toggle} ${s.toggleOn}`}>⌖ Visual grounding</span>
      </div>
      {CHUNKS.map((c) => (
        <div key={c.head} className={s.chunk}>
          <div className={s.chHead}>
            <span>{c.head}</span>
            <span>{c.tok}</span>
          </div>
          <div className={s.chText}>{c.text}</div>
        </div>
      ))}
    </>
  );
}

export function ExtractPane() {
  return (
    <>
      <div className={s.rowInline}>
        <span className={s.dim}>
          Template: <code>PaperMeta</code>
        </span>
        <span className={s.grow} />
        <button className={s.miniact}>Edit template</button>
        <button className={s.miniact}>Export JSON</button>
      </div>
      {EXTRACT_FIELDS.map(([k, v]) => (
        <div key={k} className={s.field}>
          <span className={s.fieldK}>{k}</span>
          <span className={s.fieldV}>{v}</span>
        </div>
      ))}
    </>
  );
}

export function InsightsPane() {
  return (
    <>
      {INSIGHT_METERS.map((m) => (
        <div key={m.label} className={s.meter}>
          <span className={s.mlbl}>{m.label}</span>
          <span className={s.track}>
            <span className={s.fillg} style={{ width: `${m.value * 100}%` }} />
          </span>
          <span className={s.mval}>{m.value.toFixed(2)}</span>
        </div>
      ))}
      <div className={s.enrSummary}>
        Enrichments applied:{' '}
        {ENRICHMENTS.map((e) => (
          <span key={e} className={`${s.badge} ${s.bEnr}`}>
            {e}
          </span>
        ))}
      </div>
    </>
  );
}
