import type { Extension, ExtensionTag } from './sampleData';
import s from '../page.module.css';

const CATEGORY_CLASS: Record<string, string> = {
  doc: s.catDoc,
  speech: s.catSpeech,
  search: s.catSearch,
  forecasting: s.catFcst,
  developer: s.catInt,
  evaluator: s.catInt,
  flows: s.catInt,
};

function Tag({ tag }: { tag: ExtensionTag }) {
  const cls = [s.tag, tag.category ? CATEGORY_CLASS[tag.category] : '', tag.size ? s.tagSize : '']
    .filter(Boolean)
    .join(' ');
  return <span className={cls}>{tag.label}</span>;
}

export default function ExtensionCard({
  ext,
  selected,
  onSelect,
}: {
  ext: Extension;
  selected?: boolean;
  onSelect?: () => void;
}) {
  return (
    <div
      className={`${s.extRow} ${selected ? s.extRowSel : ''}`}
      role="button"
      tabIndex={0}
      onClick={onSelect}
      onKeyDown={(e) => {
        if (e.key === 'Enter' || e.key === ' ') {
          e.preventDefault();
          onSelect?.();
        }
      }}
    >
      <div className={s.extIco}>{ext.icon}</div>
      <div className={s.extBody}>
        <div className={s.extName}>
          {ext.name}
          {ext.verified && <span className={s.verified}>✔</span>}
        </div>
        <div className={s.extPub}>
          {ext.rating != null ? (
            <>
              {ext.publisher} · <span className={s.stars}>★</span> {ext.rating}
              {ext.installs ? ` · ${ext.installs}` : ''}
            </>
          ) : (
            ext.publisher
          )}
        </div>
        <div className={s.extDesc}>{ext.description}</div>
        <div className={s.extTags}>
          {ext.tags.map((t) => (
            <Tag key={t.label} tag={t} />
          ))}
        </div>
      </div>
      {ext.installed ? (
        <button className={s.installed} type="button">
          ✓ Installed
        </button>
      ) : (
        <button className={s.install} type="button">
          {ext.installLabel ?? 'Install'}
        </button>
      )}
    </div>
  );
}
