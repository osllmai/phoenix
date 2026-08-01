'use client';

import { useEffect, useState } from 'react';

import { FONT_NOTICE_EVENT } from './appearanceStore';
import s from './fontPicker.module.css';

export function FontNotice() {
  const [msg, setMsg] = useState<string | null>(null);

  useEffect(() => {
    const onNotice = () => {
      setMsg("Couldn't load that font — try again when online.");
    };
    window.addEventListener(FONT_NOTICE_EVENT, onNotice);
    return () => window.removeEventListener(FONT_NOTICE_EVENT, onNotice);
  }, []);

  if (msg == null) return null;
  return (
    <div className={s.fontNotice} role="status">
      {msg}
      <button type="button" className={s.fontNoticeClose} onClick={() => setMsg(null)} aria-label="Dismiss">
        ✕
      </button>
    </div>
  );
}
