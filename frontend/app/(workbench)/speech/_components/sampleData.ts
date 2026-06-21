export type SpeechState = 'success' | 'empty' | 'first-run' | 'loading' | 'error' | 'denied';

export type Segment = {
  start: string;
  end: string;
  speaker?: string;
  text: string;
};

export type SessionChip = { label: string; tone?: 'green' | 'amber' };

export type WhisperModel = { name: string; label: string };

export type DownloadCard = { name: string; meta: string; recommended?: boolean };

export const WHISPER_MODELS: WhisperModel[] = [
  { name: 'tiny', label: 'Whisper tiny (ggml · 75 MB)' },
  { name: 'base', label: 'Whisper base (ggml · 142 MB)' },
  { name: 'small', label: 'Whisper small (ggml · 466 MB)' },
  { name: 'medium', label: 'Whisper medium (ggml · 1.5 GB)' },
  { name: 'large-v3', label: 'Whisper large-v3 (ggml · 2.9 GB)' },
];

export const LANGUAGES = ['Auto-detect', 'English', 'French', 'German', 'Spanish', 'Japanese'];

export const ACCEPTED_FORMATS = 'WAV · MP3 · M4A · FLAC · OGG · MP4 · MOV';

export const SAMPLE_SESSION: SessionChip[] = [
  { label: 'design-review.m4a' },
  { label: '1:47' },
  { label: 'English · 0.97', tone: 'green' },
  { label: 'Whisper small' },
  { label: 'on-device', tone: 'amber' },
  { label: '8 segments · 2 speakers' },
];

export const SAMPLE_SEGMENTS: Segment[] = [
  { start: '00:00', end: '00:04', speaker: 'Speaker 1', text: 'Welcome to Phoenix — your on-device AI studio.' },
  { start: '00:04', end: '00:11', speaker: 'Speaker 1', text: 'All inference runs locally via llama.cpp. Nothing leaves your machine.' },
  { start: '00:11', end: '00:22', speaker: 'Speaker 2', text: 'You can load a GGUF model from the Models tab, then start chatting in the Chat screen.' },
  { start: '00:22', end: '00:39', speaker: 'Speaker 1', text: 'Whisper handles speech recognition here — it also runs on your hardware, using the ggml weights.' },
  { start: '00:39', end: '00:55', speaker: 'Speaker 2', text: 'Export the transcript as SRT, VTT, plain text or Markdown — or push it straight into Documents or a Chat.' },
  { start: '00:55', end: '01:10', speaker: 'Speaker 1', text: 'Language is detected automatically, or you can pin it to English in the toolbar above.' },
  { start: '01:10', end: '01:29', speaker: 'Speaker 2', text: 'Toggle timestamps off if you only need clean text without timecodes.' },
  { start: '01:29', end: '01:47', speaker: 'Speaker 1', text: "That's the Speech screen. Press Record or drop a file to get started." },
];

export const EXPORT_FORMATS = [
  'Plain text (.txt)',
  'Subtitles (.srt)',
  'WebVTT (.vtt)',
  'Markdown (.md)',
];

export const DOWNLOAD_CARDS: DownloadCard[] = [
  { name: 'Whisper tiny', meta: '75 MB · fastest · clear speech' },
  { name: 'Whisper small', meta: '466 MB · balanced · recommended', recommended: true },
  { name: 'Whisper large-v3', meta: '2.9 GB · highest accuracy' },
];

export const LOADING_SEGMENTS = [
  { start: '00:00', end: '00:04', widths: ['85%'] },
  { start: '00:04', end: '00:11', widths: ['70%', '50%'] },
];
