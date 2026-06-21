import s from '../page.module.css';
import { SUGGESTIONS } from './data';

export function EmptyCenter() {
  return (
    <div className={s.center}>
      <div className={s.centerBig}>💬</div>
      <h2>New conversation</h2>
      <p>Ask anything — your prompt runs fully on-device. Pick a starting point or just type.</p>
      <div className={s.suggest}>
        {SUGGESTIONS.map((x) => (
          <button key={x.title} className={s.scard}>
            <b>{x.title}</b>
            {x.body}
          </button>
        ))}
      </div>
    </div>
  );
}

export function FirstRunCenter() {
  return (
    <div className={s.center}>
      <div className={s.centerBig}>🔥</div>
      <h2>Welcome to Phoenix</h2>
      <p>
        Phoenix runs language models locally — nothing leaves your machine. Load a <code>.gguf</code>{' '}
        model to start chatting.
      </p>
      <div className={s.btnrow}>
        <button className={s.cta}>Load a model</button>
        <button className={s.ghost}>Browse Hugging Face</button>
      </div>
    </div>
  );
}

export function DeniedCenter() {
  return (
    <div className={s.center}>
      <div className={s.centerBig}>🔒</div>
      <h2>Model file unavailable</h2>
      <p>
        The selected model <code>~/models/llama-3.1-8b.gguf</code> can&apos;t be read — it was moved,
        deleted, or read permission was denied.
      </p>
      <div className={s.btnrow}>
        <button className={s.cta}>Locate file…</button>
        <button className={s.ghost}>Choose another model</button>
      </div>
    </div>
  );
}
