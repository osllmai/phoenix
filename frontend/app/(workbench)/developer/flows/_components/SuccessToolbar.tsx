'use client';

import { useState } from 'react';

import { FLOW_NAME, RUN_STATE_NOTE, SAVED_FLOWS } from './sampleData';
import s from '../page.module.css';

export default function SuccessToolbar({ onRun }: { onRun: () => void }) {
  const [libOpen, setLibOpen] = useState(false);

  return (
    <div className={s.top}>
      <span className={s.libwrap}>
        <button type="button" className={s.ghost} onClick={() => setLibOpen((v) => !v)}>
          ☰ Flows ▾
        </button>
        {libOpen && (
          <>
            <div className={s.libScrim} onClick={() => setLibOpen(false)} />
            <div className={s.libpop}>
              <h4>Saved flows</h4>
              {SAVED_FLOWS.map((f) => (
                <div key={f.id} className={s.librow}>
                  <span className={s.lname}>
                    {f.name}
                    <small>{f.meta}</small>
                  </span>
                  <button type="button" className={s.miniGhost}>
                    Open
                  </button>
                  <button type="button" className={s.miniGhost}>
                    Duplicate
                  </button>
                  <button
                    type="button"
                    className={s.miniRun}
                    onClick={() => {
                      setLibOpen(false);
                      onRun();
                    }}
                  >
                    ▶ Run
                  </button>
                </div>
              ))}
            </div>
          </>
        )}
      </span>

      <h1 className={s.flowname}>
        {FLOW_NAME} <span className={s.edit}>✎</span>
      </h1>
      <span className={s.grow} />
      <span className={s.runstate}>
        <span className={s.dot} /> {RUN_STATE_NOTE}
      </span>
      <button type="button" className={s.ghost}>
        ＋ node
      </button>
      <button type="button" className={s.ghost}>
        Save
      </button>
      <button type="button" className={s.runbtn} onClick={onRun}>
        ▶ Run…
      </button>
    </div>
  );
}
