import type { ReactNode } from 'react';

import s from '../page.module.css';
import { SAMPLE_CITES, SAMPLE_CODE } from './data';

function UserRow({ text, actions = true }: { text: ReactNode; actions?: boolean }) {
  return (
    <div className={`${s.row} ${s.rowMe}`}>
      <div className={s.msg}>
        <div className={`${s.bubble} ${s.bubbleMe}`}>{text}</div>
        {actions && (
          <div className={`${s.actions} ${s.actionsMe}`}>
            <button className={s.act}>📋 Copy</button>
            <button className={s.act}>✎ Edit</button>
          </div>
        )}
      </div>
    </div>
  );
}

export { UserRow };

export function AiRow({ children, actions }: { children: ReactNode; actions?: ReactNode }) {
  return (
    <div className={`${s.row}`}>
      <div className={s.msg}>
        <div className={`${s.bubble} ${s.bubbleAi}`}>{children}</div>
        {actions && <div className={s.actions}>{actions}</div>}
      </div>
    </div>
  );
}

function CodeBlock() {
  return (
    <div className={s.codeblock}>
      <div className={s.cbHead}>
        <span>dart</span>
        <button className={s.cbCopy}>📋 Copy</button>
      </div>
      <pre>{SAMPLE_CODE}</pre>
    </div>
  );
}

export default function SuccessThread() {
  return (
    <div className={s.thread}>
      <UserRow text={<>How do I stream tokens from llama.cpp into a Dart <code>Stream</code>?</>} />

      <AiRow
        actions={
          <>
            <button className={s.act}>📋 Copy</button>
            <button className={s.act}>↻ Regenerate</button>
            <button className={s.act}>👍</button>
            <button className={s.act}>👎</button>
          </>
        }
      >
        <div className={s.who}>Phoenix</div>
        <p>
          Spawn the local provider and read its stdout line-by-line. Map the <code>__DONE__</code>{' '}
          marker to a stream close so the partial flushes cleanly:
        </p>
        <CodeBlock />
        <p>Key points:</p>
        <ul>
          <li>
            <strong>Backpressure:</strong> the engine blocks on a full pipe, so the UI paces itself.
          </li>
          <li>
            <strong>Cancellation:</strong> send <code>__END__</code> to stdin to stop mid-generation.
          </li>
        </ul>
      </AiRow>

      <UserRow text="Perfect. Where does the roadmap say streaming lands?" />

      <AiRow
        actions={
          <>
            <button className={s.act}>📋 Copy</button>
            <button className={s.act}>↻ Regenerate</button>
          </>
        }
      >
        <div className={s.who}>
          Phoenix · streaming<span className={s.caret} />
        </div>
        <p>
          According to the indexed roadmap, token streaming over the HTTP gateway is part of the{' '}
          <strong>P11 server milestone</strong>, after the on-device path stabilizes
          <span className={s.caret} />
        </p>
        <div className={s.cites}>
          <div className={s.clabel}>⌖ 2 sources · product-roadmap-2026.docx</div>
          {SAMPLE_CITES.map((c) => (
            <div key={c.src} className={s.cite}>
              <div className={s.chHead}>
                <span className={s.chSrc}>{c.src}</span>
                <span>{c.meta}</span>
              </div>
              <div className={s.chText}>{c.text}</div>
            </div>
          ))}
        </div>
      </AiRow>
    </div>
  );
}
