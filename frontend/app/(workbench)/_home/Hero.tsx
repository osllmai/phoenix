import { Button } from '@/app/components/ui';
import { sampleModel } from './data';
import s from '../page.module.css';

export function Hero({ onSwitch }: { onSwitch?: (value: string) => void }) {
  return (
    <div className={s.hero}>
      <div className={s.heroRow}>
        <button className={s.heroCta} type="button" title="Continue chatting with this model">
          <span className={s.heroIco}>{sampleModel.icon}</span>
          <span className={s.heroBody}>
            <span className={s.heroName}>{sampleModel.name}</span>
            <span className={s.heroMeta}>
              <span>
                <span className={s.loadedDot} /> {sampleModel.status}
              </span>
              <span>{sampleModel.quant}</span>
              <span>{sampleModel.context}</span>
            </span>
          </span>
          <span className={s.heroGo}>💬 New chat ›</span>
        </button>
        <select
          className={s.switchsel}
          title="Switch model (stays on Home)"
          defaultValue=""
          onChange={(e) => onSwitch?.(e.target.value)}
        >
          <option value="">Switch…</option>
          {sampleModel.alternatives.map((alt) => (
            <option key={alt} value={alt}>
              {alt}
            </option>
          ))}
        </select>
      </div>
      <div className={s.heroStats}>
        {sampleModel.stats.map((stat) => (
          <div className={s.hstat} key={stat.k}>
            <div className={s.hstatV}>{stat.v}</div>
            <div className={s.hstatK}>{stat.k}</div>
          </div>
        ))}
      </div>
    </div>
  );
}

export function HeroEmpty({ onLoad }: { onLoad?: () => void }) {
  return (
    <div className={s.hero}>
      <div className={s.heroRow}>
        <span className={s.heroIco} style={{ opacity: 0.5 }}>
          🧠
        </span>
        <div className={s.heroBody}>
          <div className={`${s.heroName} ${s.heroNameMuted}`}>No model loaded</div>
          <div className={s.heroMeta}>
            <span>Load a model to start chatting</span>
          </div>
        </div>
        <Button onClick={onLoad}>Load a model</Button>
      </div>
    </div>
  );
}
