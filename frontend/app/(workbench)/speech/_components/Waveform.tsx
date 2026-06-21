import s from '../page.module.css';

const BAR_COUNT = 28;
const STATIC_HEIGHTS = [8, 20, 32, 16, 28, 12, 36, 24, 8, 20, 28];

export type WaveMode = 'static' | 'flat' | 'live';

export default function Waveform({ mode }: { mode: WaveMode }) {
  const bars = Array.from({ length: BAR_COUNT }, (_, i) => {
    const x = i * 10;
    if (mode === 'flat') {
      return <rect key={i} x={x} y={22} width={6} height={4} rx={3} fill="var(--border-default)" />;
    }
    if (mode === 'live') {
      return (
        <rect
          key={i}
          className={s.waveBar}
          x={x}
          y={4}
          width={6}
          height={40}
          rx={3}
          fill="var(--warning-base)"
          style={{ transformOrigin: `${x + 3}px 24px`, animationDelay: `${(i % 11) * 70}ms` }}
        />
      );
    }
    const h = STATIC_HEIGHTS[i % 11];
    return (
      <rect
        key={i}
        x={x}
        y={24 - h / 2}
        width={6}
        height={h}
        rx={3}
        fill="var(--accent-primary)"
        opacity={(0.4 + (i % 6) * 0.1).toFixed(1)}
      />
    );
  });

  return (
    <div className={s.waveform}>
      <svg viewBox="0 0 280 48" height={48} preserveAspectRatio="none">
        {bars}
      </svg>
    </div>
  );
}
