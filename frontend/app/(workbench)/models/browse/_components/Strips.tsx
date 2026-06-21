import { AUTHOR_CHIPS, type Featured } from './sampleData';
import s from '../page.module.css';

export function FeaturedStrip({ heading, items }: { heading: string; items: Featured[] }) {
  return (
    <>
      <div className={s.resultsHead}>{heading}</div>
      <div className={s.featured}>
        {items.map((f) => (
          <div key={f.id + f.rank} className={s.featCard} role="button" tabIndex={0}>
            <span className={s.featRank}>{f.rank}</span>
            <span className={s.featId}>{f.id}</span>
            <span className={s.featMeta}>
              <span>⬇ {f.downloads}</span>
              <span>♥ {f.likes}</span>
              <span>{f.meta}</span>
            </span>
          </div>
        ))}
      </div>
    </>
  );
}

export function AuthorChips() {
  return (
    <div className={s.chips}>
      {AUTHOR_CHIPS.map((a) => (
        <button key={a} type="button" className={s.chip}>
          {a}
        </button>
      ))}
    </div>
  );
}
