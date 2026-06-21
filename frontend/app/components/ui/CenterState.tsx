import type { ReactNode } from 'react';

import s from './ui.module.css';

export default function CenterState({
  icon,
  title,
  description,
  sub,
  children,
}: {
  icon?: ReactNode;
  title: string;
  description?: ReactNode;
  sub?: ReactNode;
  children?: ReactNode;
}) {
  return (
    <div className={s.center}>
      {icon != null && <div className={s.centerBig}>{icon}</div>}
      <h2>{title}</h2>
      {description != null && <p>{description}</p>}
      {children}
      {sub != null && <p className={s.sub}>{sub}</p>}
    </div>
  );
}
