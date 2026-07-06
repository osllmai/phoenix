'use client';

import Sidebar from './Sidebar';
import s from './NavDrawer.module.css';

export default function NavDrawer({ open, onClose }: { open: boolean; onClose: () => void }) {
  return (
    <div className={`${s.root} ${open ? s.open : ''}`} aria-hidden={!open}>
      <div className={s.overlay} onClick={onClose} />
      <div
        className={s.panel}
        onClick={(e) => {
          if ((e.target as HTMLElement).closest('a')) onClose();
        }}
      >
        <Sidebar />
      </div>
    </div>
  );
}
