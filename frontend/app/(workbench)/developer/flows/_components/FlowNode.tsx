'use client';

import type { FlowNode as FlowNodeData, NodeStatus } from './sampleData';
import s from '../page.module.css';

const KIND_CLASS: Record<FlowNodeData['kind'], string> = {
  trigger: s.kTrigger,
  agent: s.kAgent,
  tool: s.kTool,
  eval: s.kEval,
  ctrl: s.kCtrl,
  out: s.kOut,
};

const STATUS_CLASS: Record<NodeStatus, string> = {
  done: s.stDone,
  run: s.stRun,
  idle: s.stIdle,
  fail: s.stFail,
};

export default function FlowNode({
  node,
  selected,
  onSelect,
}: {
  node: FlowNodeData;
  selected: boolean;
  onSelect: (id: string) => void;
}) {
  const cls = [
    s.node,
    KIND_CLASS[node.kind],
    selected ? s.nodeSel : '',
    node.running ? s.nodeRunning : '',
    node.errored ? s.nodeErr : '',
  ]
    .filter(Boolean)
    .join(' ');

  return (
    <button type="button" className={cls} style={{ left: node.x, top: node.y }} onClick={() => onSelect(node.id)}>
      <span className={s.nhead}>
        <span>{node.headIcon}</span> {node.head}
      </span>
      <span className={s.nbody}>
        <span className={s.ntitle}>{node.title}</span>
        {node.sub != null && <span className={s.nsub}>{node.sub}</span>}
        {node.status != null && (
          <span className={`${s.nstat} ${STATUS_CLASS[node.status]}`}>{node.statusLabel}</span>
        )}
      </span>
    </button>
  );
}
