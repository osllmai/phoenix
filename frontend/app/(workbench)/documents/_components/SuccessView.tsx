'use client';

import { useState } from 'react';

import Inspector from './Inspector';
import Library from './Library';
import { SAMPLE_DOCS } from './sampleData';
import s from '../page.module.css';

export default function SuccessView() {
  const [selectedId, setSelectedId] = useState(SAMPLE_DOCS[0].id);

  return (
    <div className={s.successWrap}>
      <div className={s.jobbar}>
        <span className={s.jobDot} />
        Docling worker online
        <span className={s.qpill}>1 converting · 1 queued</span>
        <span className={s.grow} />
        <span>Embeddings &amp; RAG run on-device · conversion runs as a Celery backend job</span>
      </div>
      <div className={s.split}>
        <Library docs={SAMPLE_DOCS} selectedId={selectedId} onSelect={setSelectedId} />
        <Inspector />
      </div>
    </div>
  );
}
