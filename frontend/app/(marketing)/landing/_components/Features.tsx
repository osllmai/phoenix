import p from '../page.module.css';
import s from './sections.module.css';

const FEATURES = [
  {
    ico: '🧠',
    title: 'On-device inference',
    body: 'Load any .gguf model and chat instantly. llama.cpp under the hood — CPU or GPU, your call.',
  },
  {
    ico: '🔒',
    title: 'Private by default',
    body: 'Prompts, files, and history stay on your machine. No accounts, no API keys, no telemetry.',
  },
  {
    ico: '📄',
    title: 'Documents & RAG',
    body: 'Drop in PDFs and office files — converted on-device and searchable in chat.',
  },
  {
    ico: '🧩',
    title: 'Extension marketplace',
    body: 'Install features on demand and keep the core lightweight — like an editor for AI.',
  },
  {
    ico: '⌨️',
    title: 'Developer mode',
    body: 'Run agentic CLIs against a local OpenAI/Anthropic-compatible gateway, right in the app.',
  },
  {
    ico: '🖥️',
    title: 'Every platform',
    body: 'A full workbench on desktop, a companion on mobile — same models, one account-free experience.',
  },
];

export default function Features() {
  return (
    <section className={p.block} id="features">
      <div className={p.wrap}>
        <div className={p.eyebrow}>Why Phoenix</div>
        <h2 className={p.sec}>Your AI, your hardware, your rules</h2>
        <div className={s.grid}>
          {FEATURES.map((f) => (
            <div key={f.title} className={s.feat}>
              <div className={s.ico}>{f.ico}</div>
              <h3>{f.title}</h3>
              <p>{f.body}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
