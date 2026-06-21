export type FcState = 'success' | 'empty' | 'first-run' | 'loading' | 'error' | 'denied';

export type Connector = { id: string; label: string; connected?: boolean };
export type Series = { id: string; name: string; meta: string; active?: boolean };
export type ForecastRow = { step: string; p10: number; p50: number; p90: number };
export type Checkpoint = { name: string; meta: string; recommended?: boolean };

export const SAMPLE_HISTORY = [
  62, 58, 64, 67, 63, 70, 74, 71, 78, 82, 79, 86, 84, 90, 95, 92, 98, 103, 99, 107, 112, 108, 116,
  121,
];

export const SAMPLE_P50 = [
  124, 128, 131, 134, 137, 139, 142, 145, 147, 150, 152, 154, 151, 156, 159, 157, 162, 166, 163,
  168, 172, 170, 175, 179,
];

export const SAMPLE_CONNECTORS: Connector[] = [
  { id: 'upload', label: '⬆ Upload' },
  { id: 'ibkr', label: 'IBKR', connected: true },
  { id: 'webull', label: 'Webull' },
  { id: 'alpaca', label: 'Alpaca' },
  { id: 'yahoo', label: 'Yahoo' },
];

export const SAMPLE_SERIES: Series[] = [
  { id: 'aapl', name: 'AAPL · 1D', meta: '504 bars · daily · close · IBKR', active: true },
  { id: 'retail', name: 'retail_sales.csv', meta: '312 points · weekly · upload' },
  { id: 'latency', name: 'api_latency_p95', meta: '2,016 points · hourly' },
];

export const SAMPLE_ROWS: ForecastRow[] = [
  { step: '+1 · 2026-06-22', p10: 119.0, p50: 128.4, p90: 138.1 },
  { step: '+2 · 2026-06-29', p10: 121.3, p50: 131.0, p90: 141.8 },
  { step: '+3 · 2026-07-06', p10: 122.9, p50: 133.6, p90: 145.2 },
  { step: '+4 · 2026-07-13', p10: 124.1, p50: 136.0, p90: 149.0 },
  { step: '+24 · 2026-11-30', p10: 138.6, p50: 159.2, p90: 181.4 },
];

export const SAMPLE_CHECKPOINTS: Checkpoint[] = [
  { name: 'TimesFM 2.5 · 200M', meta: '~0.8 GB · 16K context · recommended', recommended: true },
  { name: 'TimesFM 2.0 · 500M', meta: '~2.0 GB · 2K context · legacy' },
];

export const SAMPLE_STATS = [
  { k: 'Next step (P50)', v: '128.4' },
  { k: 'P10–P90 (next)', v: '119–138' },
  { k: 'Trend', v: '▲ +6.2%', small: '/ horizon' },
  { k: 'MASE (backtest)', v: '0.71' },
];
