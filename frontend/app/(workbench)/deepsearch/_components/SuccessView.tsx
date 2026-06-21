'use client';

import { useState } from 'react';

import PlanTimeline from './PlanTimeline';
import SourceCard from './SourceCard';
import { SAMPLE_SOURCES, SUCCESS_STEPS, SUGGESTED_FOLLOWUPS } from './sampleData';
import s from '../page.module.css';

function Cite({ n, onClick }: { n: number; onClick: (n: number) => void }) {
  return (
    <button className={s.cite} type="button" onClick={() => onClick(n)}>
      [{n}]
    </button>
  );
}

export default function SuccessView() {
  const [hit, setHit] = useState<number | null>(null);

  return (
    <div className={s.research}>
      <div>
        <div className={s.plan}>
          <div className={s.planHead}>
            <span className={s.planTtl}>Research plan</span>
            <span className={s.grow} />
            <span className={s.planDone}>✓ Completed in 14s</span>
          </div>
          <PlanTimeline steps={SUCCESS_STEPS} />
        </div>

        <div className={s.secLabel}>Synthesized answer</div>
        <div className={s.answerPanel}>
          <p>
            Several complementary techniques cut end-to-end LLM inference latency.{' '}
            <strong>Speculative decoding</strong> uses a small draft model to propose tokens that
            the large target verifies in a single pass, giving 2–3× speedups with no quality loss{' '}
            <Cite n={1} onClick={setHit} />
            <Cite n={2} onClick={setHit} />. Tree-structured drafting (e.g. Medusa) avoids a
            separate draft model entirely by adding parallel decoding heads{' '}
            <Cite n={3} onClick={setHit} />.
          </p>
          <p>
            <strong>KV-cache compression</strong> attacks the memory-bandwidth bottleneck that
            dominates on-device generation — quantizing or evicting cache entries shrinks the
            per-token read <Cite n={4} onClick={setHit} />. Your local benchmark notes corroborate
            this: cache reads were the top cost on consumer GPUs <Cite n={5} onClick={setHit} />.
          </p>
          <p>
            Gains are largest on memory-bandwidth-bound hardware (consumer GPUs, Apple Silicon) and
            narrow on compute-bound accelerators under continuous batching{' '}
            <Cite n={1} onClick={setHit} />. A practical on-device stack pairs a 68M draft model
            with an 8B target plus 4-bit KV-cache.
          </p>
          <div className={s.answerMeta}>
            <span>5 sources · 4 web · 1 local</span>
            <span>Synthesized on-device · Llama-3.1-8B-Instruct Q4_K_M</span>
            <span>Job #a3f91b · 14s</span>
          </div>
        </div>

        <div className={s.followup}>
          <div className={s.followwrap}>
            <span className={s.followIco}>↳</span>
            <input
              className={s.followInput}
              type="text"
              placeholder="Ask a follow-up — keeps this research context…"
            />
            <button className={s.askBtn} type="button">
              Ask ▶
            </button>
          </div>
          <div className={s.suggested}>
            {SUGGESTED_FOLLOWUPS.map((q) => (
              <button className={s.chip} type="button" key={q}>
                {q}
              </button>
            ))}
          </div>
        </div>
      </div>

      <div>
        <div className={s.secLabel}>Sources ({SAMPLE_SOURCES.length})</div>
        {SAMPLE_SOURCES.map((src) => (
          <SourceCard key={src.rank} source={src} hit={hit === src.rank} />
        ))}
      </div>
    </div>
  );
}
