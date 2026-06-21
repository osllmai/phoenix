'use client';

import { useMemo, useState } from 'react';

import { PROVIDER_RAIL, SAMPLE_ONLINE_MODELS, type OnlineModel } from './sampleData';
import ModelCard from './ModelCard';
import s from '../page.module.css';

const GROUPS: { heading: string; tag: string; match: (m: OnlineModel) => boolean }[] = [
  { heading: 'OpenAI', tag: 'openai/*', match: (m) => m.provider === 'openai' },
  { heading: 'Anthropic', tag: 'anthropic/*', match: (m) => m.provider === 'anthropic' },
  {
    heading: 'Google · Mistral · Groq · DeepSeek',
    tag: 'mixed/*',
    match: (m) => ['google', 'mistral', 'groq', 'deepseek'].includes(m.provider),
  },
];

export default function SuccessView({ query }: { query: string }) {
  const [providerId, setProviderId] = useState('openai');
  const [byok, setByok] = useState(false);
  const [selected, setSelected] = useState<Set<string>>(() => new Set(['openai/gpt-4o']));
  const [defaultId, setDefaultId] = useState('openai/gpt-4o');

  const q = query.trim().toLowerCase();
  const visible = useMemo(
    () =>
      SAMPLE_ONLINE_MODELS.filter(
        (m) => q === '' || `${m.name} ${m.id} ${m.comment}`.toLowerCase().includes(q),
      ),
    [q],
  );

  const toggle = (id: string) =>
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });

  return (
    <div className={s.content}>
      <aside className={s.provlist}>
        <div className={s.provHead}>Providers</div>
        {PROVIDER_RAIL.map((p) => (
          <button
            key={p.id}
            type="button"
            className={[s.prov, providerId === p.id ? s.provSel : '', p.count == null ? s.provAvail : '']
              .filter(Boolean)
              .join(' ')}
            onClick={() => setProviderId(p.id)}
          >
            <span className={s.provDot} style={{ background: p.dot }} />
            <span className={s.provName}>{p.name}</span>
            <span className={s.provCount}>{p.count ?? '—'}</span>
          </button>
        ))}
      </aside>

      <div className={s.panelWrap}>
        {selected.size > 0 && (
          <div className={s.selBar}>
            <span className={s.selCount}>{selected.size} selected</span>
            <button type="button" className={s.selAdd}>
              Add {selected.size} model{selected.size === 1 ? '' : 's'}
            </button>
            <button type="button" className={s.selClear} onClick={() => setSelected(new Set())}>
              Clear selection
            </button>
          </div>
        )}

        <div className={s.panel}>
          <div className={s.panelHead}>
            <h2>OpenAI</h2>
            <span className={s.provtag}>openai/*</span>
          </div>
          <div className={s.byokRow}>
            <label htmlFor="byok-toggle">
              <strong>BYOK</strong> — use your own OpenAI key and pay OpenAI directly instead of
              IndoxHub credits.
            </label>
            <label className={s.toggle}>
              <input
                id="byok-toggle"
                type="checkbox"
                checked={byok}
                onChange={() => setByok((v) => !v)}
              />
              <span className={s.toggleTrack} />
              <span className={s.toggleThumb} />
            </label>
          </div>

          {GROUPS.map((g, i) => {
            const items = visible.filter(g.match);
            if (items.length === 0) return null;
            return (
              <div key={g.heading}>
                {i > 0 && (
                  <div className={`${s.panelHead} ${s.panelHeadGap}`}>
                    <h2>{g.heading}</h2>
                    <span className={s.provtag}>{g.tag}</span>
                  </div>
                )}
                {items.map((m) => (
                  <ModelCard
                    key={m.id}
                    model={m}
                    selected={selected.has(m.id)}
                    isDefault={defaultId === m.id}
                    onToggle={() => toggle(m.id)}
                    onSetDefault={() => setDefaultId(m.id)}
                  />
                ))}
              </div>
            );
          })}

          {visible.length === 0 && (
            <p className={s.noMatch}>No models match “{query}”.</p>
          )}
        </div>
      </div>
    </div>
  );
}
