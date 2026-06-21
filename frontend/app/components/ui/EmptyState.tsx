import type { ReactNode } from 'react';

import CenterState from './CenterState';
import s from './ui.module.css';

export default function EmptyState({
  icon = '🗂️',
  title,
  description,
  actions,
}: {
  icon?: ReactNode;
  title: string;
  description?: ReactNode;
  actions?: ReactNode;
}) {
  return (
    <CenterState icon={icon} title={title} description={description}>
      {actions != null && <div className={s.btnrow}>{actions}</div>}
    </CenterState>
  );
}
