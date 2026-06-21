import type { CSSProperties } from 'react';

import s from './ui.module.css';

export default function Skeleton({
  width,
  height = 14,
  radius,
  className,
}: {
  width?: number | string;
  height?: number | string;
  radius?: number | string;
  className?: string;
}) {
  const style: CSSProperties = { width, height };
  if (radius != null) style.borderRadius = radius;
  return <div className={`${s.skel} ${className ?? ''}`} style={style} />;
}
