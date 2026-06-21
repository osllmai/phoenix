import p from '../page.module.css';
import s from './sections.module.css';

export default function OpenCore() {
  return (
    <section className={p.block} id="opencore">
      <div className={p.wrap}>
        <div className={s.oc}>
          <h2>Open core, no lock-in</h2>
          <p>
            The local engine, chat, models, and documents are free and open. Optional paid
            power-features and an opt-in cloud sync stay strictly separate — you never need them to
            use Phoenix.
          </p>
          <div className={s.heroCta}>
            <a className={`${p.btn} ${p.primary} ${p.lg}`} href="/welcome">
              Get started free
            </a>
            <a className={`${p.btn} ${p.outline} ${p.lg}`} href="#">
              Read the docs
            </a>
          </div>
        </div>
      </div>
    </section>
  );
}
