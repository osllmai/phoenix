'use client';

import Link from 'next/link';

import { Button } from '@/app/components/ui';

import { SAMPLE_PATH, deriveName } from './sampleData';
import s from '../page.module.css';

export type FormErrors = { name?: string; path?: string };

export default function AddForm({
  name,
  path,
  errors,
  busy,
  onName,
  onPath,
  onBrowse,
  onSubmit,
}: {
  name: string;
  path: string;
  errors: FormErrors;
  busy: boolean;
  onName: (v: string) => void;
  onPath: (v: string) => void;
  onBrowse: () => void;
  onSubmit: () => void;
}) {
  return (
    <div className={s.scroll}>
      <p className={s.explain}>
        Register a <code>.gguf</code> file you already have on disk. Phoenix runs it entirely
        on-device — nothing is uploaded.
        <span className={s.hfSoon}>Downloading models from Hugging Face is coming soon.</span>
      </p>

      <form
        className={s.formCard}
        onSubmit={(e) => {
          e.preventDefault();
          onSubmit();
        }}
      >
        <div className={`${s.field} ${errors.path ? s.hasError : ''}`}>
          <label htmlFor="add-path">File path</label>
          <div className={s.pathRow}>
            <input
              id="add-path"
              className={`${s.input} ${s.mono}`}
              type="text"
              placeholder={SAMPLE_PATH}
              value={path}
              onChange={(e) => onPath(e.target.value)}
            />
            <button className={s.browseBtn} type="button" onClick={onBrowse}>
              Browse…
            </button>
          </div>
          {errors.path ? (
            <div className={s.errMsg}>{errors.path}</div>
          ) : (
            <div className={s.hint}>
              Pick a <code>.gguf</code> file. The file isn&apos;t copied — only its path is stored.
            </div>
          )}
        </div>

        <div className={`${s.field} ${errors.name ? s.hasError : ''}`}>
          <label htmlFor="add-name">Display name</label>
          <input
            id="add-name"
            className={s.input}
            type="text"
            placeholder="Auto-filled from the file name"
            value={name}
            onChange={(e) => onName(e.target.value)}
          />
          {errors.name ? (
            <div className={s.errMsg}>{errors.name}</div>
          ) : (
            <div className={s.hint}>
              Derived from the file name — edit it if you want a different label.
            </div>
          )}
        </div>

        <div className={s.formActions}>
          <Button type="submit" disabled={busy}>
            {busy ? 'Adding…' : 'Add to catalog'}
          </Button>
          <Link className={s.cancel} href="/models">
            Cancel
          </Link>
        </div>
      </form>
    </div>
  );
}
