import Image from 'next/image';
import type { Metadata } from 'next';

import Features from './_components/Features';
import Hero from './_components/Hero';
import HowItWorks from './_components/HowItWorks';
import OpenCore from './_components/OpenCore';
import s from './page.module.css';

export const metadata: Metadata = {
  title: 'Phoenix — Run AI entirely on your device',
  description:
    'Phoenix is a local-first AI workbench — chat, documents, and agents powered by GGUF models running on your own machine. Your data never leaves.',
};

export default function LandingPage() {
  return (
    <div className={s.page}>
      <nav className={s.nav}>
        <div className={`${s.wrap} ${s.navInner}`}>
          <span className={s.brand}>
            <Image src="/phoenix-ember.svg" alt="" width={26} height={26} />
            Phoenix
          </span>
          <div className={s.navLinks}>
            <a href="#features">Features</a>
            <a href="#how">How it works</a>
            <a href="#opencore">Open-core</a>
          </div>
          <div className={s.navCta}>
            <a className={`${s.btn} ${s.outline}`} href="#">
              GitHub ★ 4.2k
            </a>
            <a className={`${s.btn} ${s.primary}`} href="/welcome">
              Download
            </a>
          </div>
        </div>
      </nav>

      <Hero />

      <div className={s.trust}>
        <span>
          Trusted by <b>50k+</b> developers
        </span>
        <span>
          <b>★ 4.2k</b> on GitHub
        </span>
        <span>
          <b>0</b> bytes sent to the cloud
        </span>
        <span>
          <b>llama.cpp</b> GGUF engine
        </span>
        <span>
          <b>OpenAI-compatible</b> local gateway
        </span>
      </div>

      <Features />
      <HowItWorks />
      <OpenCore />

      <footer className={s.foot}>
        <div className={`${s.wrap} ${s.footInner}`}>
          <span className={s.brand}>
            <Image src="/phoenix-ember.svg" alt="" width={20} height={20} />
            Phoenix
          </span>
          <span>© 2026 NEMATI AI LLC · Local-first AI</span>
          <span className={s.footLinks}>
            <a href="#">GitHub</a>
            <a href="#">Docs</a>
            <a href="#">Privacy</a>
            <a href="/legal">Legal</a>
            <a href="/welcome">Download</a>
          </span>
        </div>
      </footer>
    </div>
  );
}
