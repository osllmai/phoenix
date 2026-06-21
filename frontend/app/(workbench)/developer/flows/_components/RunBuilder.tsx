'use client';

import FlowCanvas from './FlowCanvas';
import type { FlowNode, FlowWire } from './sampleData';
import s from '../page.module.css';

interface ProgressItem {
  icon: string;
  label: string;
  mark: string;
  markClass?: string;
}

export default function RunBuilder({
  progress,
  nodes,
  wires,
  inspector,
}: {
  progress: ProgressItem[];
  nodes: FlowNode[];
  wires: FlowWire[];
  inspector: React.ReactNode;
}) {
  return (
    <div className={s.builder}>
      <aside className={s.palette}>
        <div className={s.palGrp}>
          <h4>Run progress</h4>
          {progress.map((p) => (
            <div key={p.label} className={s.chip}>
              <span className={s.ci}>{p.icon}</span> {p.label}
              <span className={`${s.grip} ${p.markClass ?? ''}`}>{p.mark}</span>
            </div>
          ))}
        </div>
      </aside>

      <FlowCanvas nodes={nodes} wires={wires} selectedId={null} onSelect={() => {}} />

      {inspector}
    </div>
  );
}
