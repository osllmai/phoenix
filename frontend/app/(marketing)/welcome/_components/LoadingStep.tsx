import p from '../page.module.css';
import s from './result.module.css';
import StepIndicator from './StepIndicator';

export default function LoadingStep({ onCancel }: { onCancel: () => void }) {
  return (
    <div className={p.card}>
      <StepIndicator
        label="Downloading model"
        dots={[
          { content: '✓', state: 'done' },
          { content: '2', state: 'active' },
          { content: '3', state: 'todo' },
        ]}
      />
      <div className={p.body}>
        <div className={p.hero}>
          <h1 className={p.sm}>Downloading Llama 3.2 3B…</h1>
        </div>
        <div className={s.dlWrap}>
          <div className={s.spinner} />
          <div className={s.dlLabel}>Fetching Q4_K_M weights</div>
          <div className={s.dlSub}>from Hugging Face · verifying checksum</div>
          <div className={s.progress}>
            <div className={s.meta}>
              <span>1.28 GB of 2.0 GB</span>
              <span>64% · 18 MB/s</span>
            </div>
            <div className={s.track}>
              <div className={s.fill} />
            </div>
          </div>
        </div>
      </div>
      <div className={p.footer}>
        <button type="button" className={p.btnBack} onClick={onCancel}>
          Cancel
        </button>
        <span className={p.grow} />
        <span className={p.footNote}>You can keep using Phoenix while this finishes</span>
      </div>
    </div>
  );
}
