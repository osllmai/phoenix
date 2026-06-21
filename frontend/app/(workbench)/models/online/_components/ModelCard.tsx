'use client';

import type { OnlineModel } from './sampleData';
import s from '../page.module.css';

function Meta({ label, value, unit }: { label: string; value: string; unit?: string }) {
  return (
    <div className={s.meta}>
      <span className={s.metaLabel}>{label}</span>
      <span className={s.metaVal}>
        {value} {unit != null && <small>{unit}</small>}
      </span>
    </div>
  );
}

export default function ModelCard({
  model,
  selected,
  isDefault,
  onToggle,
  onSetDefault,
}: {
  model: OnlineModel;
  selected: boolean;
  isDefault: boolean;
  onToggle: () => void;
  onSetDefault: () => void;
}) {
  const cls = [s.mcard, selected ? s.mcardSel : '', isDefault ? s.mcardDefault : '']
    .filter(Boolean)
    .join(' ');

  return (
    <div className={cls}>
      <div className={s.mcardTop}>
        <input
          type="checkbox"
          className={s.mcardCheck}
          checked={selected}
          onChange={onToggle}
          aria-label={`Select ${model.name}`}
        />
        <div className={s.mcardIcon} style={{ background: model.iconBg }}>
          {model.icon}
        </div>
        <div className={s.mcardInfo}>
          <div className={s.mcardName}>
            {model.name}
            {isDefault && <span className={`${s.badge} ${s.badgeDef}`}>Default</span>}
          </div>
          <div className={s.mcardId}>{model.id}</div>
        </div>
        <div className={s.badgeRow}>
          {model.recommended && <span className={`${s.badge} ${s.badgeRec}`}>{model.recommended}</span>}
          {model.vision && <span className={`${s.badge} ${s.badgeVision}`}>Vision</span>}
          {model.tools && <span className={`${s.badge} ${s.badgeTools}`}>Tools</span>}
        </div>
      </div>

      <div className={s.mcardMeta}>
        <Meta label="Context" value={model.context} />
        <Meta label="Input" value={model.inputPrice} unit="/1M" />
        <Meta label="Output" value={model.outputPrice} unit="/1M" />
        <Meta label="Latency" value={model.latency} unit="TTFT" />
        <Meta label="Throughput" value={model.throughput} unit="tok/s" />
      </div>

      <div className={s.mcardComment}>{model.comment}</div>

      <div className={s.mcardFoot}>
        <button type="button" className={s.ghostBtn}>
          Details
        </button>
        <span className={s.grow} />
        <button
          type="button"
          className={`${s.defBtn} ${isDefault ? s.defBtnOn : ''}`}
          onClick={onSetDefault}
        >
          {isDefault ? '★ Default' : 'Set default'}
        </button>
        <button
          type="button"
          className={s.useBtn}
          title="Runs in the cloud — prompts leave your device"
        >
          ☁ Use for chat
        </button>
      </div>
    </div>
  );
}
