import s from '../page.module.css';
import { AiRow, UserRow } from './Thread';

export function LoadingThread() {
  return (
    <div className={s.thread}>
      <UserRow text="How do I stream tokens from llama.cpp?" actions={false} />
      <AiRow>
        <div className={s.who}>
          Phoenix{' '}
          <span className={s.typing}>
            <span />
            <span />
            <span />
          </span>
        </div>
        <div className={s.skeleton} style={{ width: '92%' }} />
        <div className={s.skeleton} style={{ width: '78%', marginTop: 8 }} />
        <div className={s.skeleton} style={{ width: '64%', marginTop: 8 }} />
      </AiRow>
    </div>
  );
}

export function ErrorThread() {
  return (
    <div className={s.thread}>
      <UserRow text="Explain the borrow checker." actions={false} />
      <div className={s.row}>
        <div className={s.msg}>
          <div className={`${s.bubble} ${s.errbox}`}>
            <div className={`${s.who} ${s.errWho}`}>⚠ Inference failed</div>
            <p>
              The engine process exited unexpectedly (code 134 — out of memory). The model may not be
              loaded, or this quant needs more RAM than is free.
            </p>
            <div className={s.btnrow} style={{ justifyContent: 'flex-start', marginTop: 'var(--sp-3)' }}>
              <button className={s.cta}>↻ Retry</button>
              <button className={s.ghost}>Load a smaller model</button>
              <button className={s.ghost}>Open model settings</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
