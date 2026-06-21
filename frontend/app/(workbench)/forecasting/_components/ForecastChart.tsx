import s from '../page.module.css';

const W = 640;
const H = 280;
const PAD_L = 8;
const PAD_R = 8;
const PAD_T = 12;
const PAD_B = 18;

function buildGeometry(hist: number[], p50: number[]) {
  const spread = p50.map((_, i) => 6 + i * 0.9);
  const p10 = p50.map((v, i) => v - spread[i]);
  const p90 = p50.map((v, i) => v + spread[i]);
  const nH = hist.length;
  const n = nH + p50.length;
  const all = [...hist, ...p90, ...p10];
  const lo = Math.min(...all);
  const hi = Math.max(...all);
  const x = (i: number) => PAD_L + (W - PAD_L - PAD_R) * (i / (n - 1));
  const y = (v: number) => PAD_T + (H - PAD_T - PAD_B) * (1 - (v - lo) / (hi - lo));
  const line = (arr: number[], off: number) =>
    arr.map((v, i) => `${i ? 'L' : 'M'}${x(i + off).toFixed(1)} ${y(v).toFixed(1)}`).join(' ');

  const divX = x(nH - 1);
  const band =
    `M${p90.map((v, i) => `${x(i + nH).toFixed(1)} ${y(v).toFixed(1)}`).join(' L')}` +
    ` L${p10
      .slice()
      .reverse()
      .map((v, i) => `${x(n - 1 - i).toFixed(1)} ${y(v).toFixed(1)}`)
      .join(' L')} Z`;
  const bridge = `M${x(nH - 1).toFixed(1)} ${y(hist[nH - 1]).toFixed(1)} L${x(nH).toFixed(1)} ${y(
    p50[0],
  ).toFixed(1)}`;

  return { x, y, nH, divX, band, bridge, line, p50 };
}

export default function ForecastChart({ hist, p50 }: { hist: number[]; p50: number[] }) {
  const g = buildGeometry(hist, p50);
  return (
    <div className={s.chartwrap}>
      <svg viewBox={`0 0 ${W} ${H}`} preserveAspectRatio="none">
        <rect
          x={g.divX.toFixed(1)}
          y={PAD_T}
          width={(W - PAD_R - g.divX).toFixed(1)}
          height={H - PAD_T - PAD_B}
          fill="var(--accent-subtle)"
          opacity="0.25"
        />
        <path d={g.band} fill="var(--accent-primary)" opacity="0.18" />
        <line
          x1={g.divX.toFixed(1)}
          y1={PAD_T}
          x2={g.divX.toFixed(1)}
          y2={H - PAD_B}
          stroke="var(--border-default)"
          strokeDasharray="3 3"
        />
        <path d={g.line(hist, 0)} fill="none" stroke="var(--text-secondary)" strokeWidth="2" />
        <path d={g.bridge} fill="none" stroke="var(--accent-primary)" strokeWidth="2" opacity="0.6" />
        <path
          d={g.line(p50, g.nH)}
          fill="none"
          stroke="var(--accent-primary)"
          strokeWidth="2.5"
          strokeDasharray="6 4"
        />
        <circle
          cx={g.x(g.nH).toFixed(1)}
          cy={g.y(p50[0]).toFixed(1)}
          r="3.5"
          fill="var(--accent-primary)"
        />
        <text
          x={(g.divX + 6).toFixed(1)}
          y={PAD_T + 12}
          fill="var(--text-tertiary)"
          fontSize="11"
          fontFamily="var(--font-mono)"
        >
          now
        </text>
      </svg>
      <div className={s.legend}>
        <span>
          <span className={`${s.swatch} ${s.hist}`} /> History
        </span>
        <span>
          <span className={`${s.swatch} ${s.fcst}`} /> Forecast (P50)
        </span>
        <span>
          <span className={`${s.swatch} ${s.band}`} /> P10–P90 interval
        </span>
      </div>
    </div>
  );
}
