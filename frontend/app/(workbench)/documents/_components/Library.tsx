import type { DocStatus, SampleDoc } from './sampleData';
import s from '../page.module.css';

const STATUS_LABEL: Record<DocStatus, string> = {
  queued: '• Queued',
  converting: '⟳ Transcribing…',
  converted: '◎ Converted',
  embedded: '✓ Embedded',
  failed: '✕ Failed',
};

function DocRow({
  doc,
  selected,
  onSelect,
}: {
  doc: SampleDoc;
  selected: boolean;
  onSelect: (id: string) => void;
}) {
  return (
    <div
      className={`${s.docRow} ${selected ? s.docSel : ''}`}
      onClick={() => onSelect(doc.id)}
      role="button"
      tabIndex={0}
    >
      {doc.status !== 'converting' && doc.status !== 'queued' && (
        <button className={s.rowChat} title="Chat with this document">
          💬 Chat
        </button>
      )}
      <span className={s.docIcon}>{doc.icon}</span>
      <div className={s.docBody}>
        <div className={s.docTitle}>{doc.title}</div>
        <div className={s.docMeta}>{doc.meta}</div>
        <div className={s.docTags}>
          <span className={`${s.badge} ${s[`b_${doc.format}`]}`}>{doc.formatLabel}</span>
          {doc.tags.map((t) => (
            <span key={t.label} className={`${s.badge} ${t.kind === 'enr' ? s.bEnr : s.bPipe}`}>
              {t.label}
            </span>
          ))}
          <span className={`${s.status} ${s[`s_${doc.status}`]}`}>{STATUS_LABEL[doc.status]}</span>
        </div>
        {doc.progress && (
          <>
            <div className={s.progressBar}>
              <div className={s.progressFill} style={{ width: `${doc.progress.fill}%` }} />
            </div>
            <div className={s.rowJob}>
              <span className={s.rowEta}>{doc.progress.etaLabel}</span>
              <button>Cancel</button>
              <button>Notify me when done</button>
            </div>
          </>
        )}
      </div>
      <div className={s.docGrade}>
        conf
        <b className={doc.gradeWarn ? s.gradeWarn : ''}>{doc.grade ?? '—'}</b>
      </div>
    </div>
  );
}

export default function Library({
  docs,
  selectedId,
  onSelect,
}: {
  docs: SampleDoc[];
  selectedId: string;
  onSelect: (id: string) => void;
}) {
  return (
    <div className={s.library}>
      <div className={s.libHead}>
        <span>Library</span>
        <span className={s.grow} />
        <span>{docs.length} documents</span>
      </div>
      {docs.map((d) => (
        <DocRow key={d.id} doc={d} selected={d.id === selectedId} onSelect={onSelect} />
      ))}
    </div>
  );
}
