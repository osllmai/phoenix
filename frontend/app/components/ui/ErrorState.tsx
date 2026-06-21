import type { ReactNode } from 'react';

import s from './ui.module.css';

export default function ErrorState({
  icon = '⚠️',
  title,
  heading,
  message,
  actions,
  sub,
  variant = 'error',
}: {
  icon?: ReactNode;
  title: string;
  heading: string;
  message: ReactNode;
  actions?: ReactNode;
  sub?: ReactNode;
  variant?: 'error' | 'warning';
}) {
  return (
    <div className={s.center}>
      <div className={s.centerBig}>{icon}</div>
      <h2>{title}</h2>
      <div className={variant === 'warning' ? s.warnbox : s.errbox}>
        <h3>{heading}</h3>
        <p>{message}</p>
        {actions != null && (
          <div className={s.btnrow} style={{ justifyContent: 'flex-start' }}>
            {actions}
          </div>
        )}
      </div>
      {sub != null && <p className={s.sub}>{sub}</p>}
    </div>
  );
}
