'use client';

import type { ReactNode } from 'react';

import s from '../page.module.css';

export function Field({
  name,
  desc,
  children,
}: {
  name: string;
  desc?: ReactNode;
  children: ReactNode;
}) {
  return (
    <div className={s.field}>
      <div className={s.fieldLabel}>
        <div className={s.lname}>{name}</div>
        {desc != null && <div className={s.ldesc}>{desc}</div>}
      </div>
      <div className={s.control}>{children}</div>
    </div>
  );
}

export function Block({ head, children }: { head?: string; children: ReactNode }) {
  return (
    <div className={s.block}>
      {head != null && <h3 className={s.blockHead}>{head}</h3>}
      {children}
    </div>
  );
}

export function Select({
  value,
  onChange,
  options,
}: {
  value: string;
  onChange: (v: string) => void;
  options: readonly string[];
}) {
  return (
    <select className={s.select} value={value} onChange={(e) => onChange(e.target.value)}>
      {options.map((o) => (
        <option key={o}>{o}</option>
      ))}
    </select>
  );
}

export function RadioPills({
  name,
  value,
  onChange,
  options,
}: {
  name: string;
  value: string;
  onChange: (v: string) => void;
  options: readonly string[];
}) {
  return (
    <div className={s.radioGroup}>
      {options.map((o) => (
        <label key={o} className={`${s.radioPill} ${value === o ? s.sel : ''}`}>
          <input type="radio" name={name} checked={value === o} onChange={() => onChange(o)} />
          {o}
        </label>
      ))}
    </div>
  );
}

export function Toggle({ on, onChange }: { on: boolean; onChange: (v: boolean) => void }) {
  return (
    <>
      <label className={s.toggle}>
        <input type="checkbox" checked={on} onChange={(e) => onChange(e.target.checked)} />
        <span className={s.toggleTrack} />
        <span className={s.toggleThumb} />
      </label>
      <span className={s.toggleState}>{on ? 'On' : 'Off'}</span>
    </>
  );
}

export function Range({
  value,
  onChange,
  min,
  max,
  unit,
}: {
  value: number;
  onChange: (v: number) => void;
  min: number;
  max: number;
  unit?: string;
}) {
  return (
    <>
      <input
        className={s.range}
        type="range"
        min={min}
        max={max}
        value={value}
        onChange={(e) => onChange(Number(e.target.value))}
      />
      <span className={s.rangeVal}>{value}</span>
      {unit != null && <span className={s.unit}>{unit}</span>}
    </>
  );
}
