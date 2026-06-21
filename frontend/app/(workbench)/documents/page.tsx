'use client';

import { useState } from 'react';

import {
  Button,
  CenterState,
  EmptyState,
  ErrorState,
  PageHeader,
  Skeleton,
} from '@/app/components/ui';

import SuccessView from './_components/SuccessView';
import { FILTERS, FORMAT_CHIPS } from './_components/sampleData';
import s from './page.module.css';

type DocState = 'success' | 'empty' | 'first-run' | 'loading' | 'error' | 'denied';

const STATES: DocState[] = ['success', 'empty', 'first-run', 'loading', 'error', 'denied'];

export default function DocumentsPage() {
  const [state, setState] = useState<DocState>('success');
  const [filter, setFilter] = useState<string>('All');

  return (
    <>
      <PageHeader
        title="Documents"
        actions={
          <>
            <input className={s.search} placeholder="Search across converted text…" />
            <div className={s.devSwitch}>
              {STATES.map((st) => (
                <button
                  key={st}
                  className={`${s.devBtn} ${state === st ? s.devOn : ''}`}
                  onClick={() => setState(st)}
                >
                  {st}
                </button>
              ))}
            </div>
            <Button variant="ghost">💬 Chat with documents</Button>
            <Button>＋ Add document</Button>
          </>
        }
      >
        <div className={s.filters}>
          {FILTERS.map((f) => (
            <button
              key={f}
              className={`${s.fpill} ${filter === f ? s.fpillOn : ''}`}
              onClick={() => setFilter(f)}
            >
              {f}
            </button>
          ))}
        </div>
      </PageHeader>

      <div className={s.body}>{renderState(state)}</div>
    </>
  );
}

function renderState(state: DocState) {
  switch (state) {
    case 'success':
      return <SuccessView />;
    case 'loading':
      return <LoadingView />;
    case 'empty':
      return (
        <EmptyState
          icon="📭"
          title="No documents match"
          description="No documents match this filter or search. Clear the filter, or add a new file to your library."
          actions={
            <>
              <Button variant="ghost">Clear filters</Button>
              <Button>＋ Add document</Button>
            </>
          }
        />
      );
    case 'first-run':
      return <FirstRunView />;
    case 'error':
      return (
        <ErrorState
          title="Conversion failed"
          heading="q3-annual-report-draft.pdf — Docling worker error"
          message="The Celery worker returned a non-zero exit code (exit 1). The backend may be offline, or the Docling container ran out of memory parsing a large PDF."
          actions={
            <>
              <Button>Retry conversion</Button>
              <Button variant="ghost">Check backend status</Button>
            </>
          }
          sub="Other documents are unaffected. If the backend is offline, start it with make up and retry."
        />
      );
    case 'denied':
      return (
        <ErrorState
          icon="🚫"
          variant="warning"
          title="File can't be added"
          heading="Unsupported or unreadable file"
          message="The file type isn't supported, or the file is locked / permission-denied on disk. Encrypted PDFs need to be unlocked first."
          actions={<Button>Choose another file</Button>}
          sub="Supported: PDF, Office, HTML, Markdown, CSV, images, audio, XML & XBRL."
        />
      );
  }
}

function LoadingView() {
  return (
    <div className={s.loading}>
      <div className={s.loadingLabel}>Loading library…</div>
      {[0, 1, 2].map((i) => (
        <div key={i} className={s.skelRow}>
          <Skeleton width={24} height={24} radius="var(--r-sm)" />
          <div className={s.skelCol}>
            <Skeleton width={`${55 - i * 6}%`} />
            <Skeleton width={`${30 - i * 4}%`} />
          </div>
          <Skeleton width={80} height={20} radius="var(--r-pill)" />
        </div>
      ))}
    </div>
  );
}

function FirstRunView() {
  return (
    <CenterState
      title=""
      sub="Conversion runs as a background job on the backend; embeddings & RAG run fully on-device."
    >
      <div className={s.dropzone}>
        <div className={s.dzIcon}>📂</div>
        <h3>Drop files here to get started</h3>
        <p>
          Phoenix converts each file to clean markdown via Docling, then indexes it on-device for
          search &amp; chat.
        </p>
        <Button>Browse files…</Button>
      </div>
      <div className={s.fmtchips}>
        {FORMAT_CHIPS.map((c) => (
          <span key={c} className={s.fmtchip}>
            {c}
          </span>
        ))}
      </div>
    </CenterState>
  );
}
