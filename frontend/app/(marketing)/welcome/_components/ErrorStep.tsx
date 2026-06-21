import p from '../page.module.css';
import s from './result.module.css';
import StepIndicator from './StepIndicator';

type Props = {
  onChooseAnother: () => void;
  onRetry: () => void;
};

export default function ErrorStep({ onChooseAnother, onRetry }: Props) {
  return (
    <div className={p.card}>
      <StepIndicator
        label="Download failed"
        dots={[
          { content: '✓', state: 'done' },
          { content: '!', state: 'err' },
          { content: '3', state: 'todo' },
        ]}
      />
      <div className={p.body}>
        <div className={p.hero}>
          <h1 className={p.sm}>Couldn&apos;t download the model</h1>
          <p>The download stopped before it completed.</p>
        </div>
        <div className={s.alertbox}>
          <span className={s.aico}>⚠</span>
          <div>
            <div className={s.atitle}>Not enough disk space</div>
            <div className={s.abody}>
              Llama 3.2 3B needs <code>2.0 GB</code> but only <code>0.7 GB</code> is free. Free up
              space, choose a smaller model (Granite 2B · 1.5 GB), or retry on a network with a
              stable connection.
            </div>
          </div>
        </div>
      </div>
      <div className={p.footer}>
        <button type="button" className={p.btnBack} onClick={onChooseAnother}>
          ← Choose another
        </button>
        <span className={p.grow} />
        <button type="button" className={p.btnGhost} onClick={onChooseAnother}>
          Free up space
        </button>
        <button type="button" className={p.btnNext} onClick={onRetry}>
          Retry download →
        </button>
      </div>
    </div>
  );
}
