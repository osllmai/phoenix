export type DetailState = 'idle' | 'loading' | 'active' | 'no-file' | 'error';

export type ModelDetail = {
  id: string;
  name: string;
  family: string;
  icon: string;
  path: string | null;
  added: string;
  liked: boolean;
  quant: string;
  size: string;
  license: string;
  contextWindow: string;
  parameters: { label: string; value: string }[];
  benchmarks: { label: string; value: string }[];
};

export const SAMPLE_MODELS: Record<string, ModelDetail> = {
  'llama-3.1-8b': {
    id: 'llama-3.1-8b',
    name: 'Llama-3.1-8B-Instruct',
    family: 'Meta · Llama 3.1',
    icon: '🧠',
    path: '/home/rshakeri/models/llama-3.1-8b-instruct-q4_k_m.gguf',
    added: '3 days ago',
    liked: true,
    quant: 'Q4_K_M',
    size: '4.92 GB',
    license: 'Llama 3.1 Community',
    contextWindow: '128K tokens',
    parameters: [
      { label: 'Architecture', value: 'Llama' },
      { label: 'Parameters', value: '8.03 B' },
      { label: 'Embedding length', value: '4096' },
      { label: 'Layers', value: '32' },
    ],
    benchmarks: [
      { label: 'MMLU', value: '69.4' },
      { label: 'GSM8K', value: '84.5' },
      { label: 'HumanEval', value: '72.6' },
    ],
  },
};

export const REPRESENTATIVE_ID = 'llama-3.1-8b';

export function pickModel(id: string): ModelDetail | null {
  if (SAMPLE_MODELS[id]) return SAMPLE_MODELS[id];
  const base = SAMPLE_MODELS[REPRESENTATIVE_ID];
  return { ...base, id };
}
