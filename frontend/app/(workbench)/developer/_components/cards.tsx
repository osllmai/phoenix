import s from '../page.module.css';
import { ENDPOINTS, MCP, ROUTES, SERVER, type Endpoint } from './sampleData';

function tagClass(tag: Endpoint['tag']) {
  if (tag === 'Anthropic') return s.tagAnthropic;
  if (tag === 'MCP') return s.tagMcp;
  return s.tagOpenai;
}

function UrlRow({ tag, url }: Endpoint) {
  return (
    <div className={s.urlRow}>
      <span className={`${s.apiTag} ${tagClass(tag)}`}>{tag}</span>
      <span className={s.url}>{url}</span>
      <button className={s.btnSm} type="button">
        Copy
      </button>
    </div>
  );
}

export function StatusUsage() {
  const stats = [
    { label: 'Bind address', value: `${SERVER.bind}:${SERVER.port}`, sub: 'loopback only', mono: true },
    { label: 'Uptime', value: SERVER.uptime, sub: `since ${SERVER.since}` },
    { label: 'Requests', value: SERVER.requests, sub: SERVER.requestsSub },
    { label: 'Throughput', value: SERVER.throughput, unit: 'tok/s', sub: 'avg last 10 req' },
    { label: 'p50 / p95 latency', value: SERVER.latency, unit: 's', sub: SERVER.latencySub },
  ];
  return (
    <div className={s.card}>
      <div className={s.cardHead}>
        <h3>Status &amp; usage</h3>
        <span className={s.grow} />
        <span className={s.hint}>on-device gateway · OpenAI + Anthropic compatible</span>
      </div>
      <div className={s.cardBody}>
        <div className={s.statGrid}>
          {stats.map((st) => (
            <div className={s.stat} key={st.label}>
              <div className={s.statLabel}>{st.label}</div>
              <div className={`${s.statValue} ${st.mono ? s.mono : ''}`}>
                {st.value}
                {st.unit != null && <span className={s.unit}> {st.unit}</span>}
              </div>
              <div className={s.statSub}>{st.sub}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

export function EndpointsCard({ endpoints = ENDPOINTS }: { endpoints?: Endpoint[] }) {
  return (
    <div className={s.card}>
      <div className={s.cardHead}>
        <h3>Exposed endpoints</h3>
        <span className={s.grow} />
        <span className={s.hint}>point any compatible SDK at these base URLs</span>
      </div>
      <div className={s.cardBody}>
        {endpoints.map((e) => (
          <UrlRow key={e.url} {...e} />
        ))}
      </div>
    </div>
  );
}

export function McpCard() {
  return (
    <div className={s.card}>
      <div className={s.cardHead}>
        <h3>MCP server</h3>
        <span className={`${s.pill} ${s.running}`}>
          <span className={s.dot} />
          Enabled
        </span>
        <span className={s.grow} />
        <span className={s.hint}>expose Phoenix tools &amp; documents to MCP clients</span>
      </div>
      <div className={s.cardBody}>
        <UrlRow tag="MCP" url={MCP.url} />
        <div className={s.routeRow}>
          <span className={s.alias}>Transport</span>
          <span className={s.arrow}>·</span>
          <span className={s.target}>
            {MCP.transport}
            <span className={s.meta}>{MCP.transportMeta}</span>
          </span>
          <select className={s.selInline} defaultValue="SSE">
            <option>SSE</option>
            <option>stdio</option>
          </select>
        </div>
        <div className={s.routeRow}>
          <span className={s.alias}>Exposed tools</span>
          <span className={s.arrow}>·</span>
          <span className={s.target}>{MCP.tools}</span>
          <button className={s.btnSm} type="button">
            Configure
          </button>
        </div>
        <div className={s.routeRow} style={{ borderBottom: 0 }}>
          <span className={s.alias}>Exposed resources</span>
          <span className={s.arrow}>·</span>
          <span className={s.target}>
            {MCP.resources}
            <span className={s.meta}>{MCP.resourcesMeta}</span>
          </span>
          <button className={s.btnSm} type="button">
            Manage
          </button>
        </div>
      </div>
    </div>
  );
}

export function ModelRouting() {
  return (
    <div className={s.card}>
      <div className={s.cardHead}>
        <h3>Model routing</h3>
        <span className={s.grow} />
        <span className={s.hint}>which loaded model serves each request</span>
      </div>
      <div className={s.cardBody}>
        {ROUTES.map((r) => (
          <div className={s.routeRow} key={r.alias}>
            <span className={s.alias}>{r.alias}</span>
            <span className={s.arrow}>→</span>
            <span className={s.target}>
              {r.target}
              <span className={s.meta}>{r.meta}</span>
            </span>
            {r.isDefault ? (
              <span className={s.badgeDef}>default</span>
            ) : (
              <button className={s.btnSm} type="button">
                Route…
              </button>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}
