import { WORKTREES, type WorktreeStatus } from './sampleData';
import s from '../page.module.css';

const WT_CLASS: Record<WorktreeStatus, string> = {
  run: s.wtRun,
  done: s.wtDone,
  wait: s.wtWait,
  block: s.wtBlock,
};

const WT_LABEL: Record<WorktreeStatus, string> = {
  run: 'running',
  done: 'done',
  wait: 'waiting',
  block: 'blocked',
};

export default function WorktreeRail({ winnerPath }: { winnerPath: string }) {
  return (
    <div className={s.rail}>
      <div className={s.railHead}>
        <h2 className={s.railTitle}>Worktrees</h2>
        <span className={s.railMeta}>{WORKTREES.length} active · 1 base</span>
      </div>

      {WORKTREES.map((wt) => {
        const win = wt.path === winnerPath;
        return (
          <div
            key={wt.path}
            className={`${s.wt} ${WT_CLASS[wt.status]} ${win ? `${s.wtWin} ${s.wtSel}` : ''}`}
          >
            <span className={s.sdot} aria-hidden />
            <div>
              <div className={s.wtName}>{wt.agent}</div>
              <div className={s.wtPath}>{wt.path}</div>
            </div>
            <div className={s.wtStat}>
              {wt.note ? (
                <span aria-label={WT_LABEL[wt.status]}>{wt.note}</span>
              ) : (
                <>
                  <span className={s.add}>+{wt.add}</span> <span className={s.del}>−{wt.del}</span>
                </>
              )}
            </div>
          </div>
        );
      })}

      <div className={s.railFoot}>
        <div className={s.basebr}>
          base: <b>app/developer</b> · clean
        </div>
        <button className={s.iconbtn} type="button">
          ＋ new worktree
        </button>
      </div>
    </div>
  );
}
