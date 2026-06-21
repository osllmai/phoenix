import type { ReactNode } from 'react';

import s from './ui.module.css';

export default function PageHeader({
  title,
  children,
  actions,
}: {
  title: string;
  children?: ReactNode;
  actions?: ReactNode;
}) {
  return (
    <header className={s.top}>
      <h1 className={s.topTitle}>{title}</h1>
      {children}
      <span className={s.topGrow} />
      {actions != null && <div className={s.topActions}>{actions}</div>}
    </header>
  );
}
