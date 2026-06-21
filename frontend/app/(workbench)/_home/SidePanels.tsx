import { Card, CardHead, CardLink } from '@/app/components/ui';
import { docLibrary, resourceMeters, serverStatus } from './data';
import s from '../page.module.css';

const pillClass = { embedded: s.pEmbedded, converting: s.pConverting, queued: s.pQueued };
const fillClass = { ok: '', warn: s.warn, hot: s.hot };

export function DocLibrary() {
  return (
    <Card>
      <CardHead title="Document library" action={<CardLink>Open Docs</CardLink>} />
      <div className={s.docCounts}>
        {docLibrary.counts.map((c) => (
          <div className={s.dcount} key={c.l}>
            <span className={s.dcountN}>{c.n}</span>
            <span className={s.dcountL}>{c.l}</span>
          </div>
        ))}
      </div>
      <div className={s.pillRow}>
        {docLibrary.pills.map((p) => (
          <span className={`${s.pill} ${pillClass[p.kind]}`} key={p.label}>
            {p.label}
          </span>
        ))}
      </div>
    </Card>
  );
}

export function ServerStatus() {
  return (
    <Card>
      <CardHead title="Local server" action={<CardLink>Manage</CardLink>} />
      <div className={s.srvHead}>
        <span className={s.srvDot} />
        <span className={s.srvState}>{serverStatus.state}</span>
        <span className={s.srvMeta}>
          · {serverStatus.host} · {serverStatus.uptime}
        </span>
      </div>
      {serverStatus.endpoints.map((ep) => (
        <div className={s.endpoint} key={ep.path}>
          <span className={s.epMethod}>{ep.method}</span>
          <code>{ep.path}</code>
          <span className={s.epGrow} />
          <span className={s.epLabel}>{ep.label}</span>
          <button className={s.copybtn} type="button">
            copy
          </button>
        </div>
      ))}
    </Card>
  );
}

export function Resources() {
  return (
    <Card>
      <CardHead title="System resources" />
      {resourceMeters.map((m) => (
        <div className={s.meter} key={m.label}>
          <span className={s.mlbl}>{m.label}</span>
          <span className={s.track}>
            <span className={`${s.fillg} ${fillClass[m.level]}`} style={{ width: `${m.pct}%` }} />
          </span>
          <span className={s.mval}>{m.value}</span>
        </div>
      ))}
    </Card>
  );
}
