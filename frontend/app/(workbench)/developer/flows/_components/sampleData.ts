export type NodeKind = 'trigger' | 'agent' | 'tool' | 'eval' | 'ctrl' | 'out';
export type NodeStatus = 'done' | 'run' | 'idle' | 'fail';

export interface FlowNode {
  id: string;
  kind: NodeKind;
  head: string;
  headIcon: string;
  title: string;
  sub?: string;
  status?: NodeStatus;
  statusLabel?: string;
  x: number;
  y: number;
  running?: boolean;
  errored?: boolean;
}

export type WireKind = 'plain' | 'ok' | 'warn' | 'loop';

export interface FlowWire {
  id: string;
  d: string;
  kind: WireKind;
}

export interface BranchLabel {
  id: string;
  text: string;
  x: number;
  y: number;
}

export interface PaletteItem {
  icon: string;
  label: string;
}

export interface PaletteGroup {
  heading: string;
  items: PaletteItem[];
}

export interface SavedFlow {
  id: string;
  name: string;
  meta: string;
}

export interface FlowTemplate {
  id: string;
  title: string;
  description: string;
  mini: string;
}

export const FLOW_NAME = 'research → draft → review → publish';
export const RUN_STATE_NOTE = 'on-device · gateway ● · 6 nodes';

export const SAMPLE_NODES: FlowNode[] = [
  {
    id: 'trigger',
    kind: 'trigger',
    head: 'Trigger',
    headIcon: '⚡',
    title: 'Manual run',
    sub: 'starts the flow',
    status: 'done',
    statusLabel: '✓ fired',
    x: 20,
    y: 48,
  },
  {
    id: 'search',
    kind: 'tool',
    head: 'Tool',
    headIcon: '🔎',
    title: 'phoenix-search',
    sub: 'DeepSearch · 8 sources',
    status: 'done',
    statusLabel: '✓ done',
    x: 268,
    y: 48,
  },
  {
    id: 'draft',
    kind: 'agent',
    head: 'Agent',
    headIcon: '🤖',
    title: 'claude-code: draft',
    sub: 'local gateway · 70B',
    status: 'done',
    statusLabel: '✓ drafted',
    x: 516,
    y: 48,
  },
  {
    id: 'gate',
    kind: 'eval',
    head: 'Evaluator · gate',
    headIcon: '⚖',
    title: 'Ragas: faithful?',
    sub: '≥ 0.8 → pass · score 0.86',
    status: 'done',
    statusLabel: '✓ 0.86 pass',
    x: 800,
    y: 212,
  },
  {
    id: 'write',
    kind: 'out',
    head: 'Output',
    headIcon: '📤',
    title: 'Write file',
    sub: 'draft.md',
    status: 'idle',
    statusLabel: '• pending',
    x: 1010,
    y: 88,
  },
  {
    id: 'revise',
    kind: 'agent',
    head: 'Agent',
    headIcon: '🤖',
    title: 'codex: revise',
    sub: 'loops back to draft',
    status: 'idle',
    statusLabel: '• not taken',
    x: 432,
    y: 390,
  },
];

export const SAMPLE_WIRES: FlowWire[] = [
  { id: 'w1', kind: 'plain', d: 'M 188 78 C 230 78, 230 78, 268 78' },
  { id: 'w2', kind: 'plain', d: 'M 436 78 C 478 78, 478 78, 516 78' },
  { id: 'w3', kind: 'plain', d: 'M 684 78 C 740 78, 740 250, 800 250' },
  { id: 'w4', kind: 'ok', d: 'M 968 230 C 1010 200, 1010 120, 1050 120' },
  { id: 'w5', kind: 'warn', d: 'M 968 270 C 1010 340, 700 420, 600 420' },
  { id: 'w6', kind: 'loop', d: 'M 516 420 C 420 420, 600 150, 600 110' },
];

export const SAMPLE_BRANCH_LABELS: BranchLabel[] = [
  { id: 'b1', text: '≥ 0.8', x: 992, y: 150 },
  { id: 'b2', text: '< 0.8 ↻ loop', x: 760, y: 360 },
];

export { PALETTE_GROUPS, SAVED_FLOWS, TEMPLATES } from './paletteData';
