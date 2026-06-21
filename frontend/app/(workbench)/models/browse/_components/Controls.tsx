'use client';

import { useState } from 'react';

import {
  CATEGORY_FILTERS,
  FORMAT_FILTERS,
  LICENSE_OPTIONS,
  QUANT_OPTIONS,
  SIZE_OPTIONS,
  SORT_MODES,
  type SortMode,
} from './sampleData';
import s from '../page.module.css';

function ChipGroup({
  label,
  options,
  value,
  onPick,
}: {
  label: string;
  options: readonly string[];
  value: string;
  onPick: (v: string) => void;
}) {
  return (
    <div className={s.fgroup}>
      <span className={s.flbl}>{label}</span>
      {options.map((opt) => (
        <button
          key={opt}
          type="button"
          className={`${s.filterChip} ${value === opt ? s.chipOn : ''}`}
          onClick={() => onPick(opt)}
        >
          {opt}
        </button>
      ))}
    </div>
  );
}

function SelectGroup({ label, options }: { label: string; options: readonly string[] }) {
  return (
    <div className={s.fgroup}>
      <span className={s.flbl}>{label}</span>
      <select className={s.filterSel} defaultValue={options[1] ?? options[0]}>
        {options.map((opt) => (
          <option key={opt}>{opt}</option>
        ))}
      </select>
    </div>
  );
}

export default function Controls({ query }: { query: string }) {
  const [source, setSource] = useState<'catalog' | 'hf'>('hf');
  const [sort, setSort] = useState<SortMode>('Downloads');
  const [desc, setDesc] = useState(true);
  const [category, setCategory] = useState('Chat');
  const [format, setFormat] = useState<string>(FORMAT_FILTERS[0]);
  const [search, setSearch] = useState(query);

  return (
    <div className={s.headControls}>
      <div className={s.controls}>
        <div className={s.sourceToggle} role="tablist" aria-label="Catalog source">
          <button
            type="button"
            role="tab"
            className={source === 'catalog' ? s.toggleOn : ''}
            onClick={() => setSource('catalog')}
          >
            📦 Catalog · 16.5k
          </button>
          <button
            type="button"
            role="tab"
            aria-selected={source === 'hf'}
            className={source === 'hf' ? s.toggleOn : ''}
            onClick={() => setSource('hf')}
          >
            ☁ Hugging Face
          </button>
        </div>
        <input
          className={s.searchHf}
          type="search"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Search name, org, type or capability…"
        />
        <div className={s.sortModes} role="group" aria-label="Sort by">
          {SORT_MODES.map((mode) => (
            <button
              key={mode}
              type="button"
              className={sort === mode ? s.toggleOn : ''}
              onClick={() => setSort(mode)}
            >
              {mode}
            </button>
          ))}
        </div>
        <button
          type="button"
          className={s.sortDir}
          title={desc ? 'Descending' : 'Ascending'}
          aria-label={desc ? 'Sort descending' : 'Sort ascending'}
          onClick={() => setDesc((v) => !v)}
        >
          {desc ? '↓' : '↑'}
        </button>
      </div>
      <div className={s.filters}>
        <ChipGroup label="Category" options={CATEGORY_FILTERS} value={category} onPick={setCategory} />
        <ChipGroup label="Format" options={FORMAT_FILTERS} value={format} onPick={setFormat} />
        <SelectGroup label="Size" options={SIZE_OPTIONS} />
        <SelectGroup label="Quant" options={QUANT_OPTIONS} />
        <SelectGroup label="License" options={LICENSE_OPTIONS} />
      </div>
    </div>
  );
}
