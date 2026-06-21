export type DsState = 'success' | 'empty' | 'first-run' | 'loading' | 'error' | 'denied';

export type Source = {
  rank: number;
  title: string;
  domain: string;
  fav: string;
  local: boolean;
  rel: number;
  snippet: string;
};

export type PlanStep = {
  label: string;
  meta: string;
  status: 'done' | 'active' | 'pending';
  badge?: string;
};

export const SAMPLE_QUERY =
  'What are the latest techniques for reducing LLM inference latency?';

export const SUCCESS_STEPS: PlanStep[] = [
  {
    label: 'Plan & expand query',
    meta: 'Decomposed into 4 sub-queries · speculative decoding, KV-cache, quantization, batching',
    status: 'done',
    badge: '✓',
  },
  {
    label: 'Search sources',
    meta: '28 web results + 6 local documents retrieved',
    status: 'done',
    badge: '✓',
  },
  {
    label: 'Read & rank',
    meta: 'Embedded with nomic-embed-text-v1.5 · top 5 selected by relevance',
    status: 'done',
    badge: '✓',
  },
  {
    label: 'Synthesize answer',
    meta: 'Grounded with inline citations · Llama-3.1-8B-Instruct',
    status: 'done',
    badge: '✓',
  },
];

export const LOADING_STEPS: PlanStep[] = [
  { label: 'Plan & expand query', meta: '4 sub-queries generated', status: 'done', badge: '✓' },
  {
    label: 'Search sources',
    meta: '28 web results + 6 local documents retrieved',
    status: 'done',
    badge: '✓',
  },
  {
    label: 'Read & rank',
    meta: 'Embedding & scoring relevance against the query…',
    status: 'active',
  },
  { label: 'Synthesize answer', meta: 'Pending', status: 'pending', badge: '4' },
];

export const SUGGESTED_FOLLOWUPS = [
  'How much memory does 4-bit KV-cache save?',
  'Which draft model size is optimal?',
  'Compare speculative decoding vs Medusa',
];

export const EXAMPLE_QUERIES = [
  'Latest techniques to reduce LLM inference latency',
  'KV-cache compression methods in 2024',
  'RAG vs long-context trade-offs',
  'How does speculative decoding work?',
];

export const SAMPLE_SOURCES: Source[] = [
  {
    rank: 1,
    title: 'Fast Inference from Transformers via Speculative Decoding',
    domain: 'research.google',
    fav: '🌐',
    local: false,
    rel: 96,
    snippet:
      'Large models made 2–3× faster with no output change: a small draft model proposes candidate tokens that the large model verifies in parallel.',
  },
  {
    rank: 2,
    title: 'A Survey of Efficient LLM Inference: Speculative Decoding & Beyond',
    domain: 'arxiv.org',
    fav: '📄',
    local: false,
    rel: 90,
    snippet:
      'Reviews draft-model design, distillation-guided drafting, and verification strategies; distilled drafts raise acceptance rates 12–18pp on domain corpora.',
  },
  {
    rank: 3,
    title: 'Medusa: LLM Acceleration with Multiple Decoding Heads',
    domain: 'github.com',
    fav: '⚙️',
    local: false,
    rel: 82,
    snippet:
      'Adds parallel decoding heads instead of a separate draft model; tree-based verification yields 2.2–3.6× speedups on consumer hardware.',
  },
  {
    rank: 4,
    title: 'KV Cache Quantization: Cutting the Memory-Bandwidth Bottleneck',
    domain: 'huggingface.co',
    fav: '🤗',
    local: false,
    rel: 78,
    snippet:
      '4-bit KV-cache quantization shrinks per-token memory reads by ~3.8×, the dominant cost for on-device autoregressive generation on bandwidth-bound GPUs.',
  },
  {
    rank: 5,
    title: 'phoenix-inference-benchmarks.pdf',
    domain: 'Local document · indexed Jun 9',
    fav: '📄',
    local: true,
    rel: 71,
    snippet:
      'Internal benchmark notes: on an RTX 3090, KV-cache reads accounted for 61% of per-token latency; speculative decoding cut median latency by 2.4×.',
  },
];
