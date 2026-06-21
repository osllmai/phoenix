export type AddState =
  | 'default'
  | 'first-run'
  | 'validating'
  | 'importing'
  | 'success'
  | 'loading'
  | 'empty'
  | 'error'
  | 'denied';

export const STATES: AddState[] = [
  'default',
  'first-run',
  'validating',
  'importing',
  'success',
  'loading',
  'empty',
  'error',
  'denied',
];

export const SAMPLE_PATH = '/home/you/models/llama-3.1-8b-instruct-q4_k_m.gguf';

export const SAMPLE_RESULT = {
  name: 'Llama 3.1 8B Instruct Q4_K_M',
  sub: "Registered — it's now in your local models list. Load it and start chatting in one step.",
};

export function deriveName(path: string): string {
  const file = path.split(/[\\/]/).pop() ?? '';
  return file
    .replace(/\.gguf$/i, '')
    .replace(/[-_]+/g, ' ')
    .replace(/\b\w/g, (c) => c.toUpperCase())
    .trim();
}
