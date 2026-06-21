export type DocStatus = 'queued' | 'converting' | 'converted' | 'embedded' | 'failed';
export type DocFormat = 'pdf' | 'office' | 'img' | 'audio' | 'web';

export type DocTag = { label: string; kind: 'pipe' | 'enr' };

export type SampleDoc = {
  id: string;
  icon: string;
  title: string;
  meta: string;
  format: DocFormat;
  formatLabel: string;
  status: DocStatus;
  tags: DocTag[];
  grade?: string;
  gradeWarn?: boolean;
  progress?: { fill: number; etaLabel: string };
};

export const SAMPLE_DOCS: SampleDoc[] = [
  {
    id: 'llama-report',
    icon: '📄',
    title: 'llama-3-technical-report.pdf',
    meta: '312 pages · 8.4 MB · Jun 9',
    format: 'pdf',
    formatLabel: 'PDF',
    status: 'embedded',
    grade: 'A',
    tags: [
      { label: 'Standard', kind: 'pipe' },
      { label: '⌗ tables', kind: 'enr' },
      { label: '∑ formulas', kind: 'enr' },
    ],
  },
  {
    id: 'roadmap',
    icon: '📝',
    title: 'product-roadmap-2026.docx',
    meta: '28 pages · 1.1 MB · Jun 8',
    format: 'office',
    formatLabel: 'DOCX',
    status: 'embedded',
    grade: 'A',
    tags: [{ label: 'Standard', kind: 'pipe' }],
  },
  {
    id: 'invoice',
    icon: '🖼️',
    title: 'scanned-invoice-batch.png',
    meta: '3 pages · 4.0 MB · Jun 8',
    format: 'img',
    formatLabel: 'IMG',
    status: 'converted',
    grade: 'B',
    gradeWarn: true,
    tags: [
      { label: 'VLM · GraniteDocling', kind: 'pipe' },
      { label: 'OCR', kind: 'pipe' },
    ],
  },
  {
    id: 'call',
    icon: '🎙️',
    title: 'design-review-call.mp3',
    meta: '48 min · 46 MB · Jun 11',
    format: 'audio',
    formatLabel: 'AUDIO',
    status: 'converting',
    progress: { fill: 42, etaLabel: '~2 min left' },
    tags: [{ label: 'ASR · Whisper', kind: 'pipe' }],
  },
  {
    id: 'filing',
    icon: '🧾',
    title: '10-k-filing.xbrl',
    meta: 'Financial report · 2.3 MB · Jun 11',
    format: 'web',
    formatLabel: 'XBRL',
    status: 'queued',
    tags: [],
  },
];

export const FILTERS = ['All', 'PDF', 'Office', 'Images', 'Audio', 'Web · XML'] as const;

export const FORMAT_CHIPS = [
  'PDF', 'DOCX', 'PPTX', 'XLSX', 'HTML', 'Markdown', 'AsciiDoc', 'CSV',
  'PNG / JPG / TIFF', 'WAV / MP3 (ASR)', 'XML · USPTO · PMC', 'XBRL',
];

export const INSPECTOR = {
  title: 'llama-3-technical-report.pdf',
  sub: [
    'PDF · 312 pages · 8.4 MB',
    'Standard pipeline · TableFormer (accurate)',
    'Confidence A · 0.94',
  ],
  actions: ['⤓ Export ▾', '🌐 Translate', '🛡 Mask PII', '💬 Chat with this', '↻ Re-convert'],
};
