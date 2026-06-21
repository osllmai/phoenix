import p from '../page.module.css';
import s from './sections.module.css';

const STEPS = [
  {
    title: 'Install Phoenix',
    body: 'Grab the desktop app for your OS. No sign-up — it runs fully offline.',
  },
  {
    title: 'Add a model',
    body: 'Point Phoenix at a .gguf on disk. It registers the path — your file never moves.',
  },
  {
    title: 'Load & chat',
    body: "Hit Load, and the on-device engine starts answering. That's it.",
  },
];

export default function HowItWorks() {
  return (
    <section className={p.block} id="how">
      <div className={p.wrap}>
        <div className={p.eyebrow}>Three steps</div>
        <h2 className={p.sec}>From download to chatting in minutes</h2>
        <div className={s.steps}>
          {STEPS.map((step) => (
            <div key={step.title} className={s.step}>
              <h3>{step.title}</h3>
              <p>{step.body}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
