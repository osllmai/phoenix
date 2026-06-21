'use client';

import { useState } from 'react';

import s from '../page.module.css';
import { ChatHead, CloudConfirm, StaticPicker } from './ChatHead';
import { DeniedCenter, EmptyCenter, FirstRunCenter } from './CenterStates';
import Composer from './Composer';
import { SysBar } from './ChatTop';
import SuccessThread from './Thread';
import { ErrorThread, LoadingThread } from './StateThreads';
import type { ChatState } from './data';

export default function ChatColumn({ state }: { state: ChatState }) {
  const [cloud, setCloud] = useState(false);
  const openCloud = () => setCloud(true);

  return (
    <section className={s.chat}>
      <div className={s.state}>{render(state, openCloud)}</div>
      <CloudConfirm open={cloud} onClose={() => setCloud(false)} />
    </section>
  );
}

function render(state: ChatState, onCloud: () => void) {
  switch (state) {
    case 'success':
      return (
        <>
          <ChatHead
            onCloud={onCloud}
            badges={
              <>
                <span className={s.badge}>ctx 4096</span>
                <span className={s.badge}>42 tok/s</span>
              </>
            }
          />
          <SysBar />
          <SuccessThread />
          <Composer
            rag
            value="It flushes the partial token and then…"
            generating
            hintLeft="Generating… click ■ to stop · Enter to send"
            hintRight="312 / 4096 tokens · 7% context"
          />
        </>
      );
    case 'empty':
      return (
        <>
          <ChatHead onCloud={onCloud} badges={<span className={s.badge}>ctx 4096</span>} />
          <EmptyCenter />
          <Composer hintRight="0 / 4096 tokens" />
        </>
      );
    case 'first-run':
      return (
        <>
          <ChatHead onCloud={onCloud} picker={<StaticPicker label="No model loaded" dotColor="var(--text-disabled)" />} />
          <FirstRunCenter />
          <Composer
            disabled
            placeholder="Load a model to begin…"
            hintLeft="A model must be loaded before chatting"
            hintRight="—"
          />
        </>
      );
    case 'loading':
      return (
        <>
          <ChatHead
            onCloud={onCloud}
            picker={<StaticPicker label="Llama-3.1-8B-Instruct" dotColor="var(--warning-base)" />}
            badges={<span className={s.badge}>mmap · 4.1 GB</span>}
          />
          <LoadingThread />
          <Composer
            disabled
            generating
            placeholder="Warming up the engine…"
            hintLeft="Loading weights into memory · first token incoming…"
            hintRight="— / 4096"
          />
        </>
      );
    case 'error':
      return (
        <>
          <ChatHead onCloud={onCloud} picker={<StaticPicker label="Llama-3.1-8B-Instruct" dotColor="var(--error-base)" />} />
          <ErrorThread />
          <Composer
            value="Explain the borrow checker."
            hintLeft="Last response failed — retry or switch model"
            hintRight="18 / 4096 tokens"
            hintError
          />
        </>
      );
    case 'denied':
      return (
        <>
          <ChatHead onCloud={onCloud} picker={<StaticPicker label="Llama-3.1-8B-Instruct" dotColor="var(--text-disabled)" />} />
          <DeniedCenter />
          <Composer
            disabled
            placeholder="Model unavailable…"
            hintLeft="Resolve the model path to continue"
            hintRight="—"
          />
        </>
      );
  }
}
