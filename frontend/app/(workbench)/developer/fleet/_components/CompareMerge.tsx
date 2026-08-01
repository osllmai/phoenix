'use client';

import {
  ANNOTATION_COUNT,
  BRANCH_OPTIONS,
  DIFF_FILES,
  MERGE_STATUS,
  PICK_OPTIONS,
  type DiffRow,
} from './sampleData';
import s from '../page.module.css';

const ROW_CLASS: Record<Exclude<DiffRow['kind'], 'annot'>, string> = {
  hunk: s.drowHunk,
  ctx: '',
  add: s.drowAdd,
  del: s.drowDel,
};

function DiffLine({ row }: { row: DiffRow }) {
  if (row.kind === 'annot') {
    return (
      <div className={s.annot}>
        <span className={s.annotWho}>{row.who}</span> {row.code}
      </div>
    );
  }
  return (
    <div className={`${s.drow} ${ROW_CLASS[row.kind]}`}>
      <div className={s.gut}>{row.gut}</div>
      <div className={s.code}>{row.code}</div>
    </div>
  );
}

export default function CompareMerge({
  winnerPath,
  onPick,
  fileKey,
  onFile,
}: {
  winnerPath: string;
  onPick: (path: string) => void;
  fileKey: string;
  onFile: (key: string) => void;
}) {
  const winner = PICK_OPTIONS.find((p) => p.path === winnerPath) ?? PICK_OPTIONS[0];
  const file = DIFF_FILES.find((f) => f.key === fileKey) ?? DIFF_FILES[0];

  return (
    <div className={s.compare}>
      <div className={s.cmpHead}>
        <span className={s.cmpTtl}>Compare &amp; merge</span>
        {PICK_OPTIONS.map((p) => (
          <button
            key={p.key}
            type="button"
            className={`${s.pick} ${p.path === winnerPath ? s.pickOn : ''}`}
            aria-pressed={p.path === winnerPath}
            onClick={() => onPick(p.path)}
          >
            <span className={s.pickRadio} />
            {p.name}
            {p.note && <span className={s.pickNote}> {p.note}</span>}
          </button>
        ))}
        <span className={s.grow} />
        <span className={s.annotchip}>✎ {ANNOTATION_COUNT} comment → re-run</span>
        <button className={s.ghostBtn} type="button">
          ↺ re-run losers
        </button>
      </div>

      <div className={s.filetabs}>
        {DIFF_FILES.map((f) => (
          <button
            key={f.key}
            type="button"
            className={`${s.ftab} ${f.key === fileKey ? s.ftabOn : ''}`}
            onClick={() => onFile(f.key)}
          >
            {f.name} <span className={s.fds}>{f.stat}</span>
          </button>
        ))}
        <span className={s.grow} />
        <span className={`${s.mergebadge} ${MERGE_STATUS.clean ? s.mergeClean : s.mergeWarn}`}>
          {MERGE_STATUS.label}
        </span>
        <span className={s.mergeto}>merge to</span>
        <select className={s.branchsel} title="Target branch" defaultValue={BRANCH_OPTIONS[0]}>
          {BRANCH_OPTIONS.map((b) => (
            <option key={b}>{b}</option>
          ))}
        </select>
        <button className={s.merge} type="button">
          Merge {winner.name} ⏎
        </button>
      </div>

      <div className={s.diff}>
        {file.rows.map((row, i) => (
          <DiffLine key={i} row={row} />
        ))}
        <div className={s.addnote}>
          <input placeholder={`＋ comment on a line → ships back to ${winner.name}…`} />
        </div>
      </div>
    </div>
  );
}
