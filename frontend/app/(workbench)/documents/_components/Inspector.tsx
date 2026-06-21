'use client';

import { useState } from 'react';

import { INSPECTOR } from './sampleData';
import { INSPECTOR_TABS, type InspectorTab } from './inspectorData';
import {
  ChunksPane,
  ExtractPane,
  FiguresPane,
  InsightsPane,
  MarkdownPane,
  TablesPane,
} from './InspectorPanes';
import s from '../page.module.css';

const PANES: Record<InspectorTab, () => React.ReactElement> = {
  md: MarkdownPane,
  tables: TablesPane,
  figures: FiguresPane,
  chunks: ChunksPane,
  extract: ExtractPane,
  insights: InsightsPane,
};

export default function Inspector() {
  const [tab, setTab] = useState<InspectorTab>('md');
  const Pane = PANES[tab];

  return (
    <div className={s.inspector}>
      <div className={s.inspHead}>
        <h2 className={s.inspTitle}>{INSPECTOR.title}</h2>
        <div className={s.inspSub}>
          {INSPECTOR.sub.map((x) => (
            <span key={x}>{x}</span>
          ))}
        </div>
        <div className={s.inspActions}>
          {INSPECTOR.actions.map((a) => (
            <button key={a} className={s.miniact}>
              {a}
            </button>
          ))}
        </div>
      </div>

      <div className={s.tabs}>
        {INSPECTOR_TABS.map((t) => (
          <button
            key={t.id}
            className={`${s.tab} ${tab === t.id ? s.tabOn : ''}`}
            onClick={() => setTab(t.id)}
          >
            {t.label}
          </button>
        ))}
      </div>

      <div className={s.tabbody}>
        <Pane />
      </div>
    </div>
  );
}
