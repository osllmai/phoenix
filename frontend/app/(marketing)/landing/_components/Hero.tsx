import p from '../page.module.css';
import h from './hero.module.css';
import s from './sections.module.css';

export default function Hero() {
  return (
    <header className={h.hero}>
      <div className={p.wrap}>
        <span className={h.pill}>
          <span className={h.dot} />
          100% on-device · no cloud, no API keys
        </span>
        <h1 className={h.h1}>
          Run powerful AI <span className={h.accent}>entirely on your device</span>
        </h1>
        <p className={h.lede}>
          Phoenix is a local-first AI workbench — chat, documents, and agents powered by GGUF
          models running on your own machine via llama.cpp. Your data never leaves.
        </p>
        <div className={h.heroCta}>
          <a className={`${p.btn} ${p.primary} ${p.lg}`} href="/welcome">
            Download
          </a>
          <a className={`${p.btn} ${p.outline} ${p.lg}`} href="#how">
            See how it works
          </a>
          <a className={h.altLink} href="#how">
            Other platforms ↓
          </a>
        </div>
        <div className={h.subNote}>Free &amp; open core · macOS · Windows · Linux</div>
        <div className={h.proof}>
          <b>Runs offline</b> · airplane-mode ✓ · ~40 tok/s · 0 bytes to the cloud
        </div>

        <div className={s.shot}>
          <div className={s.bar}>
            <i />
            <i />
            <i />
            <span className={s.barTitle}>Phoenix — Llama-3.1-8B-Instruct (on-device)</span>
          </div>
          <div className={s.shotBody}>
            <div className={s.rail}>
              <span className={s.on}>💬</span>
              <span>▦</span>
              <span>📄</span>
              <span>⚙</span>
            </div>
            <div className={s.canvas}>
              <div className={`${s.msg} ${s.you}`}>In one sentence, what is Phoenix?</div>
              <div className={`${s.msg} ${s.ai}`}>
                Phoenix is a local-first app that runs open LLMs on your own device — private by
                default, no cloud required.
              </div>
            </div>
          </div>
        </div>
      </div>
    </header>
  );
}
