'use client';

import { useMemo, useState } from 'react';

import RepoCard from './RepoCard';
import { FeaturedStrip } from './Strips';
import { SAMPLE_REPOS, TRENDING } from './sampleData';
import s from '../page.module.css';

function initialSelected(): number {
  return SAMPLE_REPOS.reduce(
    (n, r) => n + r.siblings.filter((sib) => sib.selected && sib.state !== 'downloaded').length,
    0,
  );
}

export default function SuccessView() {
  const startCount = useMemo(initialSelected, []);
  const [selected, setSelected] = useState(startCount);

  return (
    <div className={s.results}>
      <FeaturedStrip heading="★ Trending this week" items={TRENDING} />

      <div className={s.resultsHead}>{SAMPLE_REPOS.length} results · GGUF · ≤ 8B</div>

      {SAMPLE_REPOS.map((repo) => (
        <RepoCard key={repo.id} repo={repo} />
      ))}

      {selected > 0 && (
        <div className={s.selBar} role="status" aria-live="polite">
          <span className={s.selBarLabel}>
            {selected} selected · Download {selected} file{selected > 1 ? 's' : ''}
          </span>
          <button type="button" className={s.btnSelDl}>
            Download {selected} file{selected > 1 ? 's' : ''}
          </button>
          <button type="button" className={s.btnSelClear} onClick={() => setSelected(0)}>
            Clear
          </button>
        </div>
      )}
    </div>
  );
}
