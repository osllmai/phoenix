import { Button, Skeleton } from '@/app/components/ui';

import { AuthorChips, FeaturedStrip } from './Strips';
import { FEATURED, GATED_REPO } from './sampleData';
import s from '../page.module.css';

const SKELETONS = [
  { title: '52%', sub: '28%', body: '80%' },
  { title: '45%', sub: '24%', body: '72%' },
  { title: '58%', sub: '30%', body: '65%' },
];

export function LoadingView() {
  return (
    <div className={s.results}>
      <p className={s.searchingNote}>Searching the Hub…</p>
      {SKELETONS.map((sk, i) => (
        <div key={i} className={s.skelCard}>
          <Skeleton width={sk.title} height={12} />
          <Skeleton width={sk.sub} height={10} />
          <Skeleton width={sk.body} height={10} />
        </div>
      ))}
    </div>
  );
}

export function FirstRunView() {
  return (
    <div className={s.results}>
      <div className={`${s.center} ${s.centerLoose}`}>
        <div className={s.esIllus}>🔍</div>
        <h2>Discover models on the Hub</h2>
        <p>
          Search and download GGUF models directly from Hugging Face. Start with a trending pick or a
          popular author.
        </p>
        <AuthorChips />
      </div>
      <FeaturedStrip heading="★ Featured & trending" items={FEATURED} />
    </div>
  );
}

export function DeniedView() {
  return (
    <div className={s.results}>
      <div className={`${s.repoCard} ${s.repoOpen} ${s.repoGated}`}>
        <div className={s.repoHeader}>
          <div className={s.repoIcon}>🔒</div>
          <div className={s.repoMeta}>
            <div className={s.repoId}>{GATED_REPO.id}</div>
            <div className={s.repoAuthor}>by {GATED_REPO.author}</div>
          </div>
          <div className={s.repoStats}>
            <span className={s.stat}>
              ⬇ <b>{GATED_REPO.downloads}</b>
            </span>
            <span className={s.stat}>
              ♥ <b>{GATED_REPO.likes}</b>
            </span>
            <span className={`${s.tag} ${s.tagSize}`}>{GATED_REPO.size}</span>
            <span className={`${s.tag} ${s.tagTask}`}>{GATED_REPO.task}</span>
            <span className={`${s.tag} ${s.tagGated}`}>🔒 Gated</span>
            <span className={`${s.tag} ${s.tagLicense}`}>{GATED_REPO.license}</span>
          </div>
          <span className={s.chevron}>▶</span>
        </div>
        <div className={s.siblingList}>
          <div className={s.gatePad}>
            <div className={s.gateBanner}>
              <h3>🔒 Gated repository</h3>
              <p>
                This repo is gated. Accept the model license on huggingface.co, then add your Hugging
                Face access token in Settings to enable downloads.
              </p>
              <div className={s.btnrowStart}>
                <Button>Add HF token in Settings</Button>
                <Button variant="ghost">Accept license on HF ↗</Button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
