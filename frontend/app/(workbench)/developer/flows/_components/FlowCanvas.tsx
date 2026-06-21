'use client';

import FlowNode from './FlowNode';
import type { BranchLabel, FlowNode as FlowNodeData, FlowWire, WireKind } from './sampleData';
import s from '../page.module.css';

const WIRE_CLASS: Record<WireKind, string> = {
  plain: '',
  ok: s.wireOk,
  warn: s.wireWarn,
  loop: s.wireLoop,
};

export default function FlowCanvas({
  nodes,
  wires,
  labels = [],
  selectedId,
  onSelect,
}: {
  nodes: FlowNodeData[];
  wires: FlowWire[];
  labels?: BranchLabel[];
  selectedId: string | null;
  onSelect: (id: string) => void;
}) {
  return (
    <div className={s.canvas}>
      <div className={s.canvasInner}>
        <svg className={s.svgWires} viewBox="0 0 1180 660" preserveAspectRatio="none">
          {wires.map((w) => (
            <path key={w.id} className={`${s.wire} ${WIRE_CLASS[w.kind]}`} d={w.d} />
          ))}
        </svg>

        {nodes.map((node) => (
          <FlowNode key={node.id} node={node} selected={node.id === selectedId} onSelect={onSelect} />
        ))}

        {labels.map((label) => (
          <span key={label.id} className={s.branchlabel} style={{ left: label.x, top: label.y }}>
            {label.text}
          </span>
        ))}
      </div>
    </div>
  );
}
