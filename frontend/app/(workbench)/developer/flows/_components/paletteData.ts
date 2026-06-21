import type { FlowTemplate, PaletteGroup, SavedFlow } from './sampleData';

export const PALETTE_GROUPS: PaletteGroup[] = [
  {
    heading: '⚡ Triggers',
    items: [
      { icon: '▶', label: 'Manual run' },
      { icon: '⏱', label: 'Schedule' },
      { icon: '📂', label: 'File-drop' },
      { icon: '🪝', label: 'Local webhook' },
    ],
  },
  {
    heading: '🤖 Agents',
    items: [
      { icon: '◆', label: 'claude-code' },
      { icon: '◆', label: 'codex' },
      { icon: '◆', label: 'phoenix-code' },
      { icon: '♺', label: 'Conductor (orchestra)' },
    ],
  },
  {
    heading: '🧰 Tools',
    items: [
      { icon: '🔎', label: 'phoenix-search' },
      { icon: '📄', label: 'phoenix-doc (RAG)' },
      { icon: '$', label: 'shell' },
      { icon: '🌐', label: 'local HTTP' },
    ],
  },
  {
    heading: '⚖ Evaluators',
    items: [
      { icon: '✦', label: 'Ragas: faithfulness' },
      { icon: '✦', label: 'Ragas: relevancy' },
      { icon: '🛡', label: 'indoxJudge: safety' },
    ],
  },
  {
    heading: '🔀 Control',
    items: [
      { icon: '⑂', label: 'Branch / if' },
      { icon: '↻', label: 'Loop' },
      { icon: '⫴', label: 'Parallel fan-out' },
      { icon: '✋', label: 'Human approval' },
    ],
  },
  {
    heading: '📤 Output',
    items: [
      { icon: '💾', label: 'Write file' },
      { icon: '📦', label: 'Save artifact' },
      { icon: '🔔', label: 'Notify' },
      { icon: '⊟', label: 'Open diff' },
    ],
  },
];

export const SAVED_FLOWS: SavedFlow[] = [
  { id: 'sf1', name: 'research → draft → review', meta: '6 nodes · ran 2h ago' },
  { id: 'sf2', name: 'PR review', meta: '5 nodes · ran yesterday' },
  { id: 'sf3', name: 'doc Q&A', meta: '4 nodes · ran 3d ago' },
  { id: 'sf4', name: 'test-gen loop', meta: '4 nodes · never run' },
];

export const TEMPLATES: FlowTemplate[] = [
  {
    id: 't1',
    title: '🔬 research → draft → review',
    description: 'Search the web, draft with an agent, gate on faithfulness, publish.',
    mini: '[trigger]→[search]→[draft]→[Ragas?]→[write]',
  },
  {
    id: 't2',
    title: '🔁 PR review',
    description: 'Fan out reviewers, score, summarize, open a diff.',
    mini: '[file-drop]→[claude+codex]→[merge]→[diff]',
  },
  {
    id: 't3',
    title: '📄 doc Q&A',
    description: 'Convert + RAG over docs, answer, check grounding.',
    mini: '[trigger]→[phoenix-doc]→[answer]→[Ragas?]',
  },
  {
    id: 't4',
    title: '🧪 test-gen',
    description: 'Generate tests, run them, loop until green.',
    mini: '[trigger]→[codex:tests]→[shell:run]→[branch↻]',
  },
];
