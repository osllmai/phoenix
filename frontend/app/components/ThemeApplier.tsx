'use client';

import { useEffect } from 'react';

import {
  APPEARANCE_EVENT,
  applyAppearance,
  readAppearance,
} from '@/app/(workbench)/settings/_components/appearanceStore';

export default function ThemeApplier() {
  useEffect(() => {
    const sync = () => applyAppearance(readAppearance());
    sync();

    const media = window.matchMedia('(prefers-color-scheme: light)');
    media.addEventListener('change', sync);
    window.addEventListener(APPEARANCE_EVENT, sync);
    window.addEventListener('storage', sync);
    return () => {
      media.removeEventListener('change', sync);
      window.removeEventListener(APPEARANCE_EVENT, sync);
      window.removeEventListener('storage', sync);
    };
  }, []);

  return null;
}
