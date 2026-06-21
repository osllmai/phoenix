import type { ReactNode } from 'react';

import s from './ui.module.css';

export function Card({ children, className }: { children: ReactNode; className?: string }) {
  return <div className={`${s.card} ${className ?? ''}`}>{children}</div>;
}

export function CardHead({
  title,
  action,
}: {
  title: string;
  action?: ReactNode;
}) {
  return (
    <div className={s.cardHead}>
      <span className={s.cardTitle}>{title}</span>
      {action != null && (
        <>
          <span className={s.cardGrow} />
          {action}
        </>
      )}
    </div>
  );
}

export function CardLink({
  children,
  onClick,
}: {
  children: ReactNode;
  onClick?: () => void;
}) {
  return (
    <button className={s.cardLink} onClick={onClick} type="button">
      {children}
    </button>
  );
}
