'use client';

import { PageHeader } from '@/app/components/ui';

import s from '../page.module.css';

const DEPTHS = ['Quick', 'Standard', 'Deep'] as const;
type Depth = (typeof DEPTHS)[number];

export type Scopes = { web: boolean; local: boolean };

export default function SearchHeader({
  query,
  onQuery,
  onRun,
  scopes,
  onToggleScope,
  depth,
  onDepth,
}: {
  query: string;
  onQuery: (v: string) => void;
  onRun: () => void;
  scopes: Scopes;
  onToggleScope: (key: keyof Scopes) => void;
  depth: Depth;
  onDepth: (d: Depth) => void;
}) {
  return (
    <PageHeader title="DeepSearch">
      <div className={s.headWrap}>
        <div className={s.querywrap}>
          <span className={s.ico}>🔎</span>
          <input
            className={s.queryInput}
            type="text"
            value={query}
            placeholder="Ask a research question…"
            onChange={(e) => onQuery(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === 'Enter') {
                e.preventDefault();
                onRun();
              }
            }}
          />
        </div>
        <button className={s.runBtn} type="button" onClick={onRun}>
          Run ▶ <span className={s.kbd}>⏎</span>
        </button>
        <div className={s.headMeta}>
          <span className={s.scopeLabel}>Scope:</span>
          <button
            className={`${s.chip} ${scopes.web ? s.on : ''}`}
            type="button"
            onClick={() => onToggleScope('web')}
          >
            🌐 Web
          </button>
          <button
            className={`${s.chip} ${scopes.local ? s.on : ''}`}
            type="button"
            onClick={() => onToggleScope('local')}
          >
            📄 Local documents
          </button>
          <span className={s.scopeLabel}>Depth:</span>
          <div className={s.seg}>
            {DEPTHS.map((d) => (
              <button
                className={depth === d ? s.on : ''}
                type="button"
                key={d}
                onClick={() => onDepth(d)}
              >
                {d}
              </button>
            ))}
          </div>
          <span className={s.grow} />
          <span className={s.chip}>On-device synthesis · Llama-3.1-8B</span>
        </div>
      </div>
    </PageHeader>
  );
}
