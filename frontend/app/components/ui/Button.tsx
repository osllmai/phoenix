import type { ButtonHTMLAttributes, ReactNode } from 'react';

import s from './ui.module.css';

type Props = ButtonHTMLAttributes<HTMLButtonElement> & {
  variant?: 'cta' | 'ghost';
  children: ReactNode;
};

export default function Button({ variant = 'cta', className, children, ...rest }: Props) {
  return (
    <button className={`${variant === 'ghost' ? s.ghost : s.cta} ${className ?? ''}`} {...rest}>
      {children}
    </button>
  );
}
