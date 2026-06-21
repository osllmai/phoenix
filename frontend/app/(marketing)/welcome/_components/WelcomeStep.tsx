import Image from 'next/image';

import p from '../page.module.css';
import { WELCOME_FEATURES } from './data';
import StepIndicator from './StepIndicator';
import s from './steps.module.css';

export default function WelcomeStep({ onNext }: { onNext: () => void }) {
  return (
    <div className={p.card}>
      <StepIndicator
        label="Welcome"
        dots={[
          { content: '1', state: 'active' },
          { content: '2', state: 'todo' },
          { content: '3', state: 'todo' },
        ]}
      />
      <div className={p.body}>
        <div className={p.hero}>
          <Image src="/phoenix-ember.svg" alt="Phoenix" width={76} height={76} />
          <h1>Welcome to Phoenix</h1>
          <p>
            Run AI entirely on your own machine. Private by default — nothing leaves your computer.
          </p>
        </div>
        <div className={s.featGrid}>
          {WELCOME_FEATURES.map((f) => (
            <div key={f.title} className={s.feat}>
              <span className={s.fico}>{f.ico}</span>
              <div>
                <div className={s.ftitle}>{f.title}</div>
                <div className={s.fdesc}>{f.desc}</div>
              </div>
            </div>
          ))}
        </div>
      </div>
      <div className={p.footer}>
        <span className={p.grow} />
        <button type="button" className={p.btnNext} onClick={onNext}>
          Get started →
        </button>
      </div>
    </div>
  );
}
