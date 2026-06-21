import p from '../page.module.css';

type DotState = 'todo' | 'active' | 'done' | 'err';

type Dot = { content: string; state: DotState };

const CLASS: Record<DotState, string> = {
  todo: '',
  active: p.active,
  done: p.done,
  err: p.err,
};

export default function StepIndicator({ dots, label }: { dots: Dot[]; label: string }) {
  return (
    <>
      <div className={p.steps}>
        {dots.map((dot, i) => (
          <span key={i} style={{ display: 'contents' }}>
            <div className={`${p.dot} ${CLASS[dot.state]}`}>{dot.content}</div>
            {i < dots.length - 1 && (
              <div className={`${p.line} ${dot.state === 'done' ? p.lineDone : ''}`} />
            )}
          </span>
        ))}
      </div>
      <div className={p.stepLabel}>{label}</div>
    </>
  );
}
