'use client';

import { useMemo, useState } from 'react';

import { MockStateSwitcher } from '@/app/components/dev/MockStateSwitcher';
import { PageHeader } from '@/app/components/ui';
import { SAMPLE_EXTENSIONS, SHELL_STATS, CATEGORY_CHIPS } from './_components/sampleData';
import ExtensionCard from './_components/ExtensionCard';
import ExtensionDetail from './_components/ExtensionDetail';
import InstallingPane from './_components/InstallingPane';
import LoadingPane from './_components/LoadingPane';
import { EmptyPane, FirstRunPane, ErrorPane, DeniedPane } from './_components/StatePanes';
import s from './page.module.css';

type ViewState = 'success' | 'installing' | 'empty' | 'first-run' | 'loading' | 'error' | 'denied';

const STATES: ViewState[] = [
  'success',
  'installing',
  'empty',
  'first-run',
  'loading',
  'error',
  'denied',
];

export default function ExtensionsPage() {
  const [view, setView] = useState<ViewState>('success');
  const [query, setQuery] = useState('');
  const [category, setCategory] = useState('All');
  const [selectedId, setSelectedId] = useState(SAMPLE_EXTENSIONS[0].id);

  const groups = useMemo(() => groupExtensions(SAMPLE_EXTENSIONS, query), [query]);
  const selected =
    SAMPLE_EXTENSIONS.find((e) => e.id === selectedId) ?? SAMPLE_EXTENSIONS[0];

  return (
    <main className={s.page}>
      <PageHeader title="Extensions">
        <input
          className={s.search}
          placeholder="Search extensions…  (e.g. docling, langchain, whisper)"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
        />
        <select className={s.sortSel} aria-label="Sort extensions">
          <option>Most installed</option>
          <option>Highest rated</option>
          <option>Recently updated</option>
          <option>Name (A–Z)</option>
        </select>
        <MockStateSwitcher
          states={STATES}
          value={view}
          onChange={setView}
          className={s.switcher}
          buttonClassName={s.switch}
          activeClassName={s.switchOn}
        />
      </PageHeader>

      <div className={s.shellbar}>
        <span className={s.shellDot} />
        {SHELL_STATS.core}
        <span className={s.pill}>{SHELL_STATS.installed}</span>
        <span className={s.pill}>{SHELL_STATS.updates}</span>
        <span className={s.shellGrow} />
        <span className={s.shellNote}>{SHELL_STATS.note}</span>
      </div>

      <div className={s.cats}>
        {CATEGORY_CHIPS.map((c) => (
          <button
            key={c}
            type="button"
            className={`${s.cat} ${category === c ? s.catOn : ''}`}
            onClick={() => setCategory(c)}
          >
            {c}
          </button>
        ))}
      </div>

      <div className={s.body}>
        {view === 'success' && (
          <div className={s.split}>
            <div className={s.browse}>
              {groups.length === 0 ? (
                <p className={s.noMatch}>No extensions match your filters.</p>
              ) : (
                groups.map(([group, items]) => (
                  <div key={group}>
                    <div className={s.groupHd}>{group}</div>
                    {items.map((ext) => (
                      <ExtensionCard
                        key={ext.id}
                        ext={ext}
                        selected={ext.id === selectedId}
                        onSelect={() => setSelectedId(ext.id)}
                      />
                    ))}
                  </div>
                ))
              )}
            </div>
            <ExtensionDetail ext={selected} />
          </div>
        )}

        {view === 'installing' && <InstallingPane />}
        {view === 'loading' && <LoadingPane />}

        {view === 'empty' && (
          <EmptyPane onClear={() => setQuery('')} onBrowse={() => setCategory('All')} />
        )}
        {view === 'first-run' && <FirstRunPane />}
        {view === 'error' && <ErrorPane onRetry={() => setView('success')} />}
        {view === 'denied' && <DeniedPane />}
      </div>
    </main>
  );
}

function groupExtensions(exts: typeof SAMPLE_EXTENSIONS, query: string) {
  const q = query.trim().toLowerCase();
  const filtered = q
    ? exts.filter((e) => `${e.name} ${e.description} ${e.publisher}`.toLowerCase().includes(q))
    : exts;
  const map = new Map<string, typeof SAMPLE_EXTENSIONS>();
  for (const e of filtered) {
    const list = map.get(e.group) ?? [];
    list.push(e);
    map.set(e.group, list);
  }
  return [...map.entries()];
}
