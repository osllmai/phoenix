'use client';

import { useState } from 'react';

import AppBar from './AppBar';
import BottomNav from './BottomNav';
import NavDrawer from './NavDrawer';

export default function MobileNav() {
  const [open, setOpen] = useState(false);
  return (
    <>
      <AppBar onMenu={() => setOpen(true)} />
      <BottomNav onMore={() => setOpen(true)} />
      <NavDrawer open={open} onClose={() => setOpen(false)} />
    </>
  );
}
