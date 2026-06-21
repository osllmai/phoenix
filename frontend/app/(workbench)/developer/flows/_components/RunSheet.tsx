'use client';

import { Button } from '@/app/components/ui';
import s from '../page.module.css';

export default function RunSheet({ onClose }: { onClose: () => void }) {
  return (
    <div className={s.sheetScrim} onClick={onClose}>
      <div className={s.sheet} onClick={(e) => e.stopPropagation()}>
        <h3>Run “research → draft → review”</h3>
        <p className={s.ssub}>Provide this flow&apos;s trigger inputs, then run on-device.</p>
        <div className={s.sfld}>
          <label>Research query</label>
          <input placeholder="e.g. on-device RAG techniques 2026" />
        </div>
        <div className={s.sfld}>
          <label>Source documents (optional)</label>
          <input placeholder="drop a file or pick from Docs…" />
        </div>
        <div className={s.sfld}>
          <label>Output file</label>
          <input defaultValue="draft.md" />
        </div>
        <div className={s.srow}>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <button type="button" className={s.runbtn} onClick={onClose}>
            ▶ Run flow
          </button>
        </div>
      </div>
    </div>
  );
}
