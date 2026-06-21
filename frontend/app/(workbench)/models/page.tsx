'use client';

import { useState } from 'react';

import { useModelMutations, useModels } from '@/lib/hooks';
import type { Model } from '@/lib/api';
import SectionTabs from '@/app/components/SectionTabs';
import { MODELS_TABS } from '@/app/components/sectionTabs.config';
import s from './page.module.css';

export default function ModelsPage() {
  const { data, isLoading, isError, error } = useModels();
  const m = useModelMutations();
  const [q, setQ] = useState('');
  const [favOnly, setFavOnly] = useState(false);
  const [name, setName] = useState('');
  const [path, setPath] = useState('');

  if (isLoading) {
    return (
      <main className={s.wrap}>
        <SectionTabs items={MODELS_TABS} variant="tab" aria-label="Models sections" />
        <h1 className={s.h1}>Local models</h1>
        {[0, 1, 2].map((i) => (
          <div key={i} className={s.sk} style={{ width: `${70 - i * 10}%` }} />
        ))}
      </main>
    );
  }

  if (isError) {
    return (
      <main className={s.wrap}>
        <div className={s.center}>
          <h2>Couldn&apos;t reach the models gateway</h2>
          <p>{String((error as Error)?.message ?? error)}</p>
          <p className={s.msg}>Is the on-device gateway running? (phoenix_server)</p>
        </div>
      </main>
    );
  }

  const all = data!.data;
  const active = data!.active;
  const ql = q.trim().toLowerCase();
  const models = all.filter(
    (x) =>
      (!favOnly || x.liked) &&
      (ql === '' || x.name.toLowerCase().includes(ql) || (x.path ?? '').toLowerCase().includes(ql)),
  );

  const addModel = () => {
    if (!name.trim() || !path.trim()) return;
    m.add.mutate({ name: name.trim(), path: path.trim() });
    setName('');
    setPath('');
  };

  return (
    <main className={s.wrap}>
      <h1 className={s.h1}>Local models</h1>

      {all.length === 0 ? (
        <div className={s.center}>
          <h2>No models yet</h2>
          <p>Add a .gguf path you already have on disk to run models on-device.</p>
        </div>
      ) : (
        <>
          <div className={s.toolbar}>
            <input
              className={s.search}
              placeholder="Filter models…"
              value={q}
              onChange={(e) => setQ(e.target.value)}
            />
            <button
              className={`${s.chip} ${favOnly ? s.on : ''}`}
              onClick={() => setFavOnly((v) => !v)}
            >
              ♥ Favorites
            </button>
          </div>

          {active && (
            <div className={s.banner}>
              <span className={s.dot} />
              <div className={s.grow}>
                <div className={s.bname}>{active.name}</div>
                <div className={s.bsub}>Active · loaded in the engine</div>
              </div>
            </div>
          )}

          {models.map((x) => (
            <Row key={x.id} model={x} active={active?.id === x.id} m={m} />
          ))}
          {models.length === 0 && <p className={s.msg}>No models match your filters.</p>}
        </>
      )}

      <div className={s.add}>
        <input placeholder="Display name" value={name} onChange={(e) => setName(e.target.value)} />
        <input
          placeholder="/path/to/model.gguf"
          value={path}
          onChange={(e) => setPath(e.target.value)}
          style={{ flex: 1 }}
        />
        <button className={s.btn} onClick={addModel}>
          ＋ Add
        </button>
      </div>
    </main>
  );
}

function Row({
  model,
  active,
  m,
}: {
  model: Model;
  active: boolean;
  m: ReturnType<typeof useModelMutations>;
}) {
  return (
    <div className={`${s.row} ${active ? s.active : ''}`}>
      <div className={s.grow}>
        <div className={s.name}>{model.name}</div>
        <div className={s.path}>{model.path ?? 'No file'}</div>
      </div>
      <button className={s.heart} onClick={() => m.like.mutate({ id: model.id, liked: !model.liked })}>
        {model.liked ? '♥' : '♡'}
      </button>
      {active ? (
        <span className={s.tag}>Active</span>
      ) : (
        <button
          className={s.load}
          disabled={!model.installed || m.select.isPending}
          onClick={() => m.select.mutate(model.id)}
        >
          ▶ Load
        </button>
      )}
      <button className={s.del} onClick={() => m.remove.mutate(model.id)}>
        🗑
      </button>
    </div>
  );
}
