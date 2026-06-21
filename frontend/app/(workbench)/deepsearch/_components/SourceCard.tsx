import type { Source } from './sampleData';
import s from '../page.module.css';

export default function SourceCard({
  source,
  hit,
}: {
  source: Source;
  hit?: boolean;
}) {
  return (
    <div className={`${s.sourceCard} ${hit ? s.srcHit : ''}`}>
      <div className={s.srcTop}>
        <div className={s.srcRank}>[{source.rank}]</div>
        <div className={s.srcBody}>
          <div className={s.srcTitle}>{source.title}</div>
          <div className={s.srcDomain}>
            <span className={s.fav}>{source.fav}</span>
            {source.domain}
            {source.local && <span className={s.badgeLocal}>LOCAL</span>}
          </div>
          <div className={s.relBarWrap}>
            <div className={s.relBarTrack}>
              <div className={s.relBarFill} style={{ width: `${source.rel}%` }} />
            </div>
            <span className={s.relPct}>{source.rel}% relevant</span>
          </div>
          <div className={s.srcSnippet}>{source.snippet}</div>
          <div className={s.srcActions}>
            <button className={s.btnGhost} type="button">
              {source.local ? 'View in Docs ↗' : 'Open ↗'}
            </button>
            <button className={s.btnGhost} type="button">
              Cite
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
