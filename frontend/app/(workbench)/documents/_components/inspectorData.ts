export type InspectorTab = 'md' | 'tables' | 'figures' | 'chunks' | 'extract' | 'insights';

export const INSPECTOR_TABS: { id: InspectorTab; label: string }[] = [
  { id: 'md', label: 'Markdown' },
  { id: 'tables', label: 'Tables' },
  { id: 'figures', label: 'Figures' },
  { id: 'chunks', label: 'Chunks' },
  { id: 'extract', label: 'Extract' },
  { id: 'insights', label: 'Insights' },
];

export const TABLE_ROWS = [
  ['Llama 3 8B', '8B', '66.6', '62.2'],
  ['Llama 3 70B', '70B', '79.5', '81.7'],
  ['Llama 3 405B', '405B', '85.2', '89.0'],
];

export const FIGURES = [
  { thumb: '📈', label: 'chart', caption: 'Scaling curve of loss vs. compute (FLOPs).' },
  { thumb: '🗂️', label: 'diagram', caption: 'Transformer block with grouped-query attention.' },
  { thumb: '📊', label: 'bar chart', caption: 'Benchmark comparison across model sizes.' },
  { thumb: '🖼️', label: 'photo', caption: 'Annotation interface screenshot.' },
];

export const CHUNKS = [
  { head: 'chunk 14 · p.7', tok: '418 tok', text: 'The pre-training corpus is assembled from a variety of sources covering general knowledge…' },
  { head: 'chunk 15 · p.7–8', tok: '377 tok', text: 'We apply quality filtering and deduplication. Table headers are carried into each chunk for context…' },
  { head: 'chunk 16 · p.8', tok: '402 tok', text: 'Scaling laws guide the compute-optimal allocation between model size and training tokens…' },
];

export const EXTRACT_FIELDS = [
  ['title', 'The Llama 3 Herd of Models'],
  ['authors', 'Llama Team, AI @ Meta'],
  ['published', '2024-07-31'],
  ['max_params', '405B'],
  ['context_window', '128,000 tokens'],
];

export const INSIGHT_METERS = [
  { label: 'Layout', value: 0.96 },
  { label: 'OCR', value: 0.91 },
  { label: 'Table structure', value: 0.93 },
  { label: 'Parse', value: 0.95 },
];

export const ENRICHMENTS = [
  'code understanding', 'formula → LaTeX', 'picture classification', 'picture description',
];
