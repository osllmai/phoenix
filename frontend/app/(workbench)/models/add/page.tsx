'use client';

import Link from 'next/link';
import { useState } from 'react';

import {
  Button,
  CenterState,
  EmptyState,
  ErrorState,
  PageHeader,
  Skeleton,
} from '@/app/components/ui';

import AddForm, { type FormErrors } from './_components/AddForm';
import SuccessView from './_components/SuccessView';
import { SAMPLE_PATH, STATES, deriveName, type AddState } from './_components/sampleData';
import s from './page.module.css';

export default function ModelsAddPage() {
  const [state, setState] = useState<AddState>('default');
  const [name, setName] = useState('');
  const [path, setPath] = useState('');
  const [nameTouched, setNameTouched] = useState(false);
  const [errors, setErrors] = useState<FormErrors>({});

  const onPath = (v: string) => {
    setPath(v);
    if (!nameTouched) setName(deriveName(v));
  };

  const onName = (v: string) => {
    setNameTouched(true);
    setName(v);
  };

  const onBrowse = () => onPath(SAMPLE_PATH);

  const onSubmit = () => {
    const next: FormErrors = {};
    if (!path.trim()) next.path = 'Choose a .gguf file';
    if (!name.trim()) next.name = 'Name is required';
    setErrors(next);
    setState(Object.keys(next).length > 0 ? 'validating' : 'success');
  };

  return (
    <>
      <PageHeader
        title="Add a local model"
        actions={
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
        }
      >
        <Link className={s.back} href="/models">
          ← Local models
        </Link>
      </PageHeader>

      <div className={s.body}>
        {(state === 'default' || state === 'validating') && (
          <AddForm
            name={name}
            path={path}
            errors={state === 'validating' ? errors : {}}
            busy={false}
            onName={onName}
            onPath={onPath}
            onBrowse={onBrowse}
            onSubmit={onSubmit}
          />
        )}
        {state === 'importing' && (
          <CenterState
            icon="⏳"
            title="Importing model…"
            description="Registering the .gguf path in your on-device catalog. Nothing is uploaded."
            sub="This usually takes a moment."
          />
        )}
        {state === 'success' && <SuccessView name={name} />}
        {state === 'loading' && <LoadingView />}
        {state === 'first-run' && <FirstRunView onAdd={() => setState('default')} />}
        {state === 'empty' && (
          <EmptyState
            icon="📭"
            title="No .gguf files found"
            description="We didn't find any .gguf models in your usual folders. Point Phoenix at a file you already have on disk."
            actions={<Button onClick={() => setState('default')}>Browse for a file…</Button>}
          />
        )}
        {state === 'error' && (
          <ErrorState
            title="Couldn't add the model"
            heading="The path is unreadable"
            message="Phoenix couldn't read the file at that path. It may have moved, been renamed, or the drive is no longer mounted."
            actions={
              <>
                <Button onClick={() => setState('default')}>Choose another file</Button>
                <Button variant="ghost" onClick={() => setState('default')}>
                  Back to form
                </Button>
              </>
            }
            sub="Your other models are unaffected."
          />
        )}
        {state === 'denied' && (
          <ErrorState
            icon="🚫"
            variant="warning"
            title="File can't be added"
            heading="Permission denied"
            message="The file is locked or permission-denied on disk, so Phoenix can't open it. Adjust the file permissions, then try again."
            actions={<Button onClick={() => setState('default')}>Choose another file</Button>}
            sub="Only .gguf files Phoenix can read on-device can be registered."
          />
        )}
      </div>
    </>
  );
}

function FirstRunView({ onAdd }: { onAdd: () => void }) {
  return (
    <CenterState
      title=""
      sub="Phoenix runs models entirely on-device — the .gguf file is never uploaded, only its path is stored."
    >
      <div className={s.dropzone}>
        <div className={s.dzIcon}>📂</div>
        <h3>Add your first local model</h3>
        <p>
          Register a <code>.gguf</code> file you already have on disk to start running models
          on-device.
        </p>
        <Button onClick={onAdd}>Browse for a .gguf…</Button>
      </div>
    </CenterState>
  );
}

function LoadingView() {
  return (
    <div className={s.scroll}>
      <div className={s.formCard}>
        {[0, 1].map((i) => (
          <div key={i} className={s.skelField}>
            <Skeleton width={`${20 - i * 4}%`} height={12} />
            <Skeleton width="100%" height={36} radius="var(--r-md)" />
          </div>
        ))}
        <Skeleton width={140} height={36} radius="var(--r-md)" />
      </div>
    </div>
  );
}
