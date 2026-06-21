export type EvalState =
  | 'success'
  | 'empty'
  | 'first-run'
  | 'loading'
  | 'error'
  | 'denied';

export type Evaluator = {
  id: string;
  icon: string;
  name: string;
  badge: { label: string; tone: 'first' | 'oss' };
  description: string;
  metrics: string[];
  judges: string[];
  enabled: boolean;
};

export type Meter = {
  label: string;
  value: number;
  display: string;
  fill: number;
  tone: 'pass' | 'warn' | 'fail';
  op: '≥' | '≤';
  threshold: string;
  verdict: 'PASS' | 'WARN' | 'FAIL';
};

export type Scorecard = {
  candidate: string;
  run: string;
  verdict: { label: string; pass: boolean };
  meters: Meter[];
  note: string;
};

export const SAMPLE_EVALUATORS: Evaluator[] = [
  {
    id: 'indoxjudge',
    icon: '⚖️',
    name: 'indoxJudge',
    badge: { label: 'first-party', tone: 'first' },
    description:
      'Broad LLM evaluation plus a safety layer — toxicity, bias and hallucination detection — and RAG quality metrics. Built by osllmai, bundled first-party.',
    metrics: ['faithfulness', 'hallucination', 'toxicity', 'bias', 'GEval', 'BertScore', 'RAG'],
    judges: [
      'local · llama-3.1-8b (gateway)',
      'local · qwen2.5-14b (gateway)',
      'IndoxHub · gpt-4o (cloud)',
    ],
    enabled: true,
  },
  {
    id: 'ragas',
    icon: '📐',
    name: 'Ragas',
    badge: { label: 'Apache-2.0', tone: 'oss' },
    description:
      'Focused RAG metrics with automated test-data generation. Third-party (vibrantlabsai), clean to bundle commercially via a custom LLM + embeddings config.',
    metrics: [
      'faithfulness',
      'answer-relevancy',
      'context precision',
      'context recall',
      'test-data gen',
    ],
    judges: [
      'local · llama-3.1-8b (gateway)',
      'local · qwen2.5-14b (gateway)',
      'IndoxHub · claude-sonnet (cloud)',
    ],
    enabled: true,
  },
];

export const SAMPLE_SCORECARD: Scorecard = {
  candidate: 'claude-code · "draft OAuth guide"',
  run: 'run #1284 · indoxJudge · llama-3.1-8b · 12s',
  verdict: { label: '✓ quality gate: PASS (≥0.8)', pass: true },
  meters: [
    { label: 'Faithfulness', value: 0.94, display: '0.94', fill: 94, tone: 'pass', op: '≥', threshold: '0.8', verdict: 'PASS' },
    { label: 'Hallucination', value: 0.06, display: '0.06', fill: 6, tone: 'pass', op: '≤', threshold: '0.1', verdict: 'PASS' },
    { label: 'Toxicity', value: 0.01, display: '0.01', fill: 1, tone: 'pass', op: '≤', threshold: '0.1', verdict: 'PASS' },
    { label: 'Context precision', value: 0.88, display: '0.88', fill: 88, tone: 'pass', op: '≥', threshold: '0.8', verdict: 'PASS' },
    { label: 'Answer-relevancy', value: 0.76, display: '0.76', fill: 76, tone: 'warn', op: '≥', threshold: '0.8', verdict: 'WARN' },
  ],
  note: 'Thresholds are editable here and drive the matching Flows gate. Gate verdict aggregates all required metrics — one soft warning (answer-relevancy) did not fail it.',
};
