'use client';

import { useState } from 'react';

export function useFlash(): { msg: string; flash: (m: string) => void } {
  const [msg, setMsg] = useState('');
  const flash = (m: string) => {
    setMsg(m);
    window.setTimeout(() => setMsg(''), 2400);
  };
  return { msg, flash };
}

export async function copyToClipboard(text: string): Promise<boolean> {
  try {
    await navigator.clipboard.writeText(text);
    return true;
  } catch {
    return false;
  }
}
