'use client';

import type { ModelDetail } from './sample';
import s from '../page.module.css';

export default function IdentityCard({
  model,
  active,
  noFile,
  liked,
  onToggleLike,
}: {
  model: ModelDetail;
  active: boolean;
  noFile: boolean;
  liked: boolean;
  onToggleLike: () => void;
}) {
  return (
    <div className={s.idCard}>
      <div className={s.idTop}>
        <span className={s.idIcon} aria-hidden="true">
          {model.icon}
        </span>
        <div className={s.idMain}>
          <div className={s.idName}>
            {model.name}
            {active && (
              <span className={s.statusBadge}>
                <span className={`${s.statusDot} ${s.live}`} />● Active
              </span>
            )}
          </div>
          <div className={s.idFamily}>{model.family}</div>
        </div>
        <button
          type="button"
          className={`${s.iconBtn} ${liked ? s.iconLiked : ''}`}
          title={liked ? 'Unlike' : 'Like'}
          onClick={onToggleLike}
        >
          {liked ? '♥' : '♡'}
        </button>
      </div>

      <dl className={s.idRows}>
        <dt>Path</dt>
        {noFile ? (
          <dd className={s.missing}>— no file set —</dd>
        ) : (
          <dd className={s.mono}>{model.path}</dd>
        )}
        <dt>Added</dt>
        <dd>{model.added}</dd>
        <dt>Quant</dt>
        <dd className={s.mono}>{model.quant}</dd>
        <dt>Size</dt>
        <dd>{model.size}</dd>
        <dt>License</dt>
        <dd>{model.license}</dd>
        <dt>Context</dt>
        <dd>{model.contextWindow}</dd>
      </dl>
    </div>
  );
}
