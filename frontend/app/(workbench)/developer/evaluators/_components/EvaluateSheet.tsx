import { Button } from '@/app/components/ui';
import s from '../page.module.css';

export default function EvaluateSheet({ onClose }: { onClose: () => void }) {
  return (
    <div
      className={s.sheetScrim}
      onClick={(e) => {
        if (e.target === e.currentTarget) onClose();
      }}
    >
      <div className={s.sheet}>
        <h3>▶ Evaluate now</h3>
        <p className={s.ssub}>
          Score a candidate output on-device — pick what to judge and which evaluator runs.
        </p>

        <div className={s.sfld}>
          <label>Candidate</label>
          <select>
            <option>{'Last Maestro run · "draft OAuth guide"'}</option>
            <option>Last chat answer</option>
            <option>Paste text below…</option>
          </select>
        </div>

        <div className={s.sfld}>
          <label>Or paste candidate text</label>
          <textarea placeholder="Paste the model output to score…" />
        </div>

        <div className={s.sfld}>
          <label>Evaluator</label>
          <select>
            <option>indoxJudge · faithfulness + safety</option>
            <option>Ragas · RAG metrics</option>
          </select>
        </div>

        <div className={s.sfld}>
          <label>Judge model</label>
          <select>
            <option>local · llama-3.1-8b (gateway)</option>
            <option>local · qwen2.5-14b (gateway)</option>
          </select>
        </div>

        <div className={s.srow}>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button>▶ Evaluate</Button>
        </div>
      </div>
    </div>
  );
}
