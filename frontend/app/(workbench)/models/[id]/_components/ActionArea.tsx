'use client';

import { Button } from '@/app/components/ui';

import type { DetailState } from './sample';
import s from '../page.module.css';

export default function ActionArea({
  state,
  modelName,
  onLoad,
  onRetry,
  onRemove,
}: {
  state: DetailState;
  modelName: string;
  onLoad: () => void;
  onRetry: () => void;
  onRemove: () => void;
}) {
  if (state === 'loading') {
    return (
      <div className={s.actionArea}>
        <div className={s.loadingRow}>
          <span className={s.spinner} aria-hidden="true" />
          <span className={s.loadingText}>Loading {modelName} into the engine…</span>
        </div>
        <div className={s.barIndef} aria-hidden="true" />
        <Button disabled>Loading…</Button>
        <p className={s.hint}>
          No other model can be loaded until this finishes — the engine handles one load at a time.
        </p>
      </div>
    );
  }

  if (state === 'active') {
    return (
      <>
        <div className={s.actionArea}>
          <div className={s.actionRow}>
            <Button onClick={onLoad}>Open chat →</Button>
            <span className={s.statusBadge}>
              <span className={`${s.statusDot} ${s.live}`} />✓ Active
            </span>
          </div>
          <p className={s.hintStrong}>This model is loaded and serving chat.</p>
          <p className={s.hint}>
            Loading a different model from the catalog will switch to it automatically — there is no
            manual unload here.
          </p>
        </div>
        <DangerZone
          note="Removing the active model clears the active selection. The file on disk is left untouched."
          onRemove={onRemove}
        />
      </>
    );
  }

  if (state === 'no-file') {
    return (
      <>
        <div className={s.actionArea}>
          <div className={s.warnbox}>
            <h3>📂 This model has no file to load</h3>
            <p>
              Its file path is missing or was never set, so the engine has nothing to open. Re-add
              the model from a <code>.gguf</code> file on disk to make it loadable.
            </p>
          </div>
          <Button disabled>▶ Load model</Button>
          <p className={s.hint}>
            Re-add from disk to point this entry at a <code>.gguf</code> file, then it can be loaded.
          </p>
        </div>
        <DangerZone note="Removes this empty entry from your catalog." onRemove={onRemove} />
      </>
    );
  }

  if (state === 'error') {
    return (
      <div className={s.actionArea}>
        <div className={s.errbox}>
          <h3>⚠️ Couldn&apos;t load this model</h3>
          <p>The engine failed to bring this model up. The most common causes are:</p>
          <ul>
            <li>The file was <strong>moved or deleted</strong> since it was added</li>
            <li>The model is <strong>too large for available RAM</strong> (out of memory)</li>
            <li>The file is <strong>corrupt</strong> or only a partial download</li>
            <li>An <strong>unsupported architecture</strong> for the bundled engine</li>
            <li>A <strong>missing shard</strong> from a multi-part GGUF</li>
          </ul>
          <div className={s.btnrow}>
            <Button onClick={onRetry}>Retry load</Button>
            <Button variant="ghost" onClick={onRemove}>
              Remove from catalog
            </Button>
          </div>
        </div>
        <p className={s.hint}>
          If this is a memory issue, try a smaller or more heavily quantized model.
        </p>
        <p className={s.hint}>
          The previously-active model (if any) is still active — this failed load did not change it.
        </p>
      </div>
    );
  }

  return (
    <>
      <div className={s.actionArea}>
        <Button onClick={onLoad}>▶ Load model</Button>
        <p className={s.hint}>
          Loads into the on-device engine and becomes the active model for chat.
        </p>
      </div>
      <DangerZone
        note="Removes this model from your catalog. The file on disk is left untouched."
        onRemove={onRemove}
      />
    </>
  );
}

function DangerZone({ note, onRemove }: { note: string; onRemove: () => void }) {
  return (
    <div className={s.actionArea}>
      <div className={s.dangerZone}>
        <p className={s.hint}>{note}</p>
        <button type="button" className={s.btnDanger} onClick={onRemove}>
          🗑 Remove from catalog
        </button>
      </div>
    </div>
  );
}
