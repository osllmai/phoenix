export type BrowseState = 'success' | 'empty' | 'first-run' | 'loading' | 'error' | 'denied';

export const BROWSE_STATES: BrowseState[] = [
  'success',
  'empty',
  'first-run',
  'loading',
  'error',
  'denied',
];

export type Capability = 'text' | 'code' | 'vision' | 'audio' | 'embed';
export type Runnability = 'ok' | 'tight' | 'big';
export type SiblingState = 'available' | 'downloaded' | 'downloading';

export type GgufMeta = { label: string; kind?: 'arch' | 'ctx' | 'tmpl' };

export type Sibling = {
  filename: string;
  quant: string;
  size: string;
  recommended?: boolean;
  state: SiblingState;
  selected?: boolean;
  download?: { url: string; speed: string; percent: number };
};

export type Repo = {
  id: string;
  author: string;
  variants: string;
  downloads: string;
  likes: string;
  capability: Capability;
  capabilityLabel: string;
  runnability: Runnability;
  runnabilityLabel: string;
  size: string;
  ram: string;
  gpu?: boolean;
  license: string;
  defaultOpen?: boolean;
  gguf: GgufMeta[];
  siblings: Sibling[];
};

export type Featured = {
  rank: string;
  id: string;
  downloads: string;
  likes: string;
  meta: string;
};

export const SORT_MODES = ['Downloads', 'Likes', 'Size', 'Name', 'Date'] as const;
export type SortMode = (typeof SORT_MODES)[number];

export const CATEGORY_FILTERS = ['All', 'Chat', 'Code', 'Vision', 'Audio', 'Embedding'] as const;
export const FORMAT_FILTERS = ['🔖 GGUF', 'Safetensors'] as const;
export const SIZE_OPTIONS = ['Any size', '≤ 8B params', '8–34B', '34B+'] as const;
export const QUANT_OPTIONS = ['Any quant', 'Q4_K_M', 'Q5_K_M', 'Q6_K', 'Q8_0'] as const;
export const LICENSE_OPTIONS = ['Any license', 'Apache-2.0', 'MIT', 'Llama', 'Gated only'] as const;
export const AUTHOR_CHIPS = [
  'bartowski',
  'TheBloke',
  'Qwen',
  'lmstudio-community',
  'unsloth',
  'ibm-granite',
] as const;

export const TRENDING: Featured[] = [
  { rank: '#1 trending', id: 'Qwen/Qwen2.5-7B-Instruct-GGUF', downloads: '980K', likes: '3.4K', meta: '7B' },
  { rank: '#2 trending', id: 'ibm-granite/granite-3.1-8b-instruct-GGUF', downloads: '410K', likes: '1.2K', meta: '8B' },
  { rank: '#3 trending', id: 'CompendiumLabs/bge-small-en-v1.5-gguf', downloads: '620K', likes: '540', meta: 'embeddings' },
];

export const FEATURED: Featured[] = [
  { rank: '#1 trending', id: 'Qwen/Qwen2.5-7B-Instruct-GGUF', downloads: '980K', likes: '3.4K', meta: '7B · text-gen' },
  { rank: '#2 trending', id: 'bartowski/Llama-3.1-8B-Instruct-GGUF', downloads: '2.4M', likes: '8.2K', meta: '8B · text-gen' },
  { rank: '#3 trending', id: 'ibm-granite/granite-3.1-8b-instruct-GGUF', downloads: '410K', likes: '1.2K', meta: '8B · text-gen' },
  { rank: 'popular', id: 'CompendiumLabs/bge-small-en-v1.5-gguf', downloads: '620K', likes: '540', meta: 'embeddings' },
  { rank: 'popular', id: 'microsoft/Phi-4-GGUF', downloads: '350K', likes: '2.1K', meta: '14B · text-gen' },
  { rank: 'popular', id: 'TheBloke/Mistral-7B-Instruct-v0.2-GGUF', downloads: '1.8M', likes: '5.8K', meta: '7B · text-gen' },
];

export const SAMPLE_REPOS: Repo[] = [
  {
    id: 'bartowski/Llama-3.1-8B-Instruct-GGUF',
    author: 'bartowski',
    variants: '9 quant variants · updated 3d ago',
    downloads: '2.4M',
    likes: '8.2K',
    capability: 'text',
    capabilityLabel: 'text-generation',
    runnability: 'big',
    runnabilityLabel: 'Too large · needs 16 GB',
    size: '8B',
    ram: '16 GB RAM',
    gpu: true,
    license: 'MIT',
    defaultOpen: true,
    gguf: [
      { label: 'arch: llama', kind: 'arch' },
      { label: 'context: 131 072', kind: 'ctx' },
      { label: 'chat_template ✓', kind: 'tmpl' },
      { label: 'bos: <|begin_of_text|>' },
      { label: 'eos: <|eot_id|>' },
    ],
    siblings: [
      { filename: 'Llama-3.1-8B-Instruct-Q2_K.gguf', quant: 'Q2_K · smallest', size: '2.96 GB', state: 'available', selected: true },
      { filename: 'Llama-3.1-8B-Instruct-Q4_K_M.gguf', quant: 'Q4_K_M · recommended', size: '4.92 GB', recommended: true, state: 'downloaded' },
      {
        filename: 'Llama-3.1-8B-Instruct-Q5_K_M.gguf',
        quant: 'Q5_K_M',
        size: '6.14 GB',
        state: 'downloading',
        download: {
          url: 'https://huggingface.co/bartowski/Llama-3.1-8B-Instruct-GGUF/resolve/main/Llama-3.1-8B-Instruct-Q5_K_M.gguf',
          speed: '3.2 MB/s · 6.14 GB · 62% · ~14 min left',
          percent: 62,
        },
      },
      { filename: 'Llama-3.1-8B-Instruct-Q8_0.gguf', quant: 'Q8_0 · highest fidelity', size: '8.54 GB', state: 'available' },
    ],
  },
  {
    id: 'TheBloke/Mistral-7B-Instruct-v0.2-GGUF',
    author: 'TheBloke',
    variants: '11 quant variants',
    downloads: '1.8M',
    likes: '5.8K',
    capability: 'text',
    capabilityLabel: 'text-generation',
    runnability: 'ok',
    runnabilityLabel: '✓ Runs on your device',
    size: '7B',
    ram: '8 GB RAM',
    license: 'Apache-2.0',
    gguf: [
      { label: 'arch: mistral', kind: 'arch' },
      { label: 'context: 32 768', kind: 'ctx' },
      { label: 'chat_template ✓', kind: 'tmpl' },
    ],
    siblings: [
      { filename: 'Mistral-7B-Instruct-v0.2.Q4_K_M.gguf', quant: 'Q4_K_M · recommended', size: '4.37 GB', recommended: true, state: 'available', selected: true },
      { filename: 'Mistral-7B-Instruct-v0.2.Q8_0.gguf', quant: 'Q8_0 · highest fidelity', size: '7.70 GB', state: 'available' },
    ],
  },
  {
    id: 'Qwen/Qwen2.5-7B-Instruct-GGUF',
    author: 'Qwen',
    variants: '8 quant variants',
    downloads: '980K',
    likes: '3.4K',
    capability: 'text',
    capabilityLabel: 'text-generation',
    runnability: 'tight',
    runnabilityLabel: 'Tight (~8 GB RAM)',
    size: '7B',
    ram: '8 GB RAM',
    license: 'Qwen',
    gguf: [],
    siblings: [],
  },
  {
    id: 'CompendiumLabs/bge-small-en-v1.5-gguf',
    author: 'CompendiumLabs',
    variants: '3 quant variants',
    downloads: '620K',
    likes: '540',
    capability: 'embed',
    capabilityLabel: 'embedding',
    runnability: 'ok',
    runnabilityLabel: '✓ Runs on your device',
    size: '33M',
    ram: '1 GB RAM',
    license: 'MIT',
    gguf: [],
    siblings: [],
  },
];

export const GATED_REPO = {
  id: 'meta-llama/Llama-3.1-8B-Instruct',
  author: 'Meta',
  downloads: '9.1M',
  likes: '22.4K',
  size: '8B',
  task: 'text-generation',
  license: 'Llama 3.1',
};
