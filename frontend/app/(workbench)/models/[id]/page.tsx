'use client';

import Link from 'next/link';
import { use, useState } from 'react';

import {
  CenterState,
  EmptyState,
  ErrorState,
  PageHeader,
  Skeleton,
} from '@/app/components/ui';
import { MockStateSwitcher, mockStatesEnabled } from '@/app/components/dev/MockStateSwitcher';

import ActionArea from './_components/ActionArea';
import IdentityCard from './_components/IdentityCard';
import SpecsCard from './_components/SpecsCard';
import { pickModel, type DetailState } from './_components/sample';
import s from './page.module.css';

type LoadStatus = 'ready' | 'fetching' | 'denied' | 'fetch-error' | 'not-found';

const STATE_TABS: DetailState[] = ['idle', 'loading', 'active', 'no-file', 'error'];
const STATUS_TABS: LoadStatus[] = ['ready', 'fetching', 'denied', 'fetch-error', 'not-found'];

export default function ModelDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = use(params);
  const model = pickModel(id);

  const [status, setStatus] = useState<LoadStatus>('ready');
  const [state, setState] = useState<DetailState>('idle');
  const [liked, setLiked] = useState(model?.liked ?? false);

  return (
    <>
      <PageHeader title={model?.name ?? 'Model'}>
        <Link className={s.backLink} href="/models">
          ← Local models
        </Link>
        <span className={s.headSep}>/</span>
      </PageHeader>

      {mockStatesEnabled && (
        <div className={s.switcher}>
          <MockStateSwitcher
            states={STATUS_TABS}
            value={status}
            onChange={setStatus}
            activeClassName={s.switchOn}
          />
          <span className={s.switchSep} />
          <MockStateSwitcher
            states={STATE_TABS}
            value={state}
            onChange={(t) => status === 'ready' && setState(t)}
            activeClassName={s.switchOn}
          />
        </div>
      )}

      <div className={s.scroll}>
        <Body
          status={status}
          state={state}
          liked={liked}
          model={model}
          onToggleLike={() => setLiked((v) => !v)}
          onState={setState}
        />
      </div>
    </>
  );
}

function Body({
  status,
  state,
  liked,
  model,
  onToggleLike,
  onState,
}: {
  status: LoadStatus;
  state: DetailState;
  liked: boolean;
  model: ReturnType<typeof pickModel>;
  onToggleLike: () => void;
  onState: (s: DetailState) => void;
}) {
  if (status === 'fetching' || model == null) {
    if (model == null) {
      return (
        <EmptyState
          icon="🔍"
          title="Model not found"
          description="No catalog entry matches this id. It may have been removed."
        />
      );
    }
    return (
      <div className={s.detail}>
        <Skeleton width="40%" height={28} />
        <Skeleton width="100%" height={140} radius="var(--r-lg)" />
        <Skeleton width="100%" height={96} radius="var(--r-lg)" />
      </div>
    );
  }

  if (status === 'not-found') {
    return (
      <EmptyState
        icon="🔍"
        title="Model not found"
        description="No catalog entry matches this id. It may have been removed."
      />
    );
  }

  if (status === 'denied') {
    return (
      <CenterState
        icon="🔒"
        title="Access denied"
        description="You don't have permission to view this model's details."
        sub="Sign in with an account that owns this catalog entry."
      />
    );
  }

  if (status === 'fetch-error') {
    return (
      <ErrorState
        title="Couldn't load model details"
        heading="Gateway unreachable"
        message="The on-device gateway didn't respond. Is phoenix_server running?"
      />
    );
  }

  return (
    <div className={s.detail}>
      <IdentityCard
        model={model}
        active={state === 'active'}
        noFile={state === 'no-file'}
        liked={liked}
        onToggleLike={onToggleLike}
      />
      <SpecsCard model={model} />
      <ActionArea
        state={state}
        modelName={model.name}
        onLoad={() => onState(state === 'idle' ? 'loading' : state)}
        onRetry={() => onState('loading')}
        onRemove={() => onState('idle')}
      />
    </div>
  );
}
