'use client';

import { useState } from 'react';

import { PageHeader } from '@/app/components/ui';

import ChatColumn from './_components/ChatColumn';
import ConvosSidebar from './_components/ConvosSidebar';
import { CHAT_STATES, type ChatState } from './_components/data';
import s from './page.module.css';

export default function ChatPage() {
  const [state, setState] = useState<ChatState>('success');

  const switcher = (
    <div className={s.switcher}>
      {CHAT_STATES.map((st) => (
        <button
          key={st}
          className={state === st ? s.switcherOn : ''}
          onClick={() => setState(st)}
        >
          {st}
        </button>
      ))}
    </div>
  );

  return (
    <>
      <PageHeader title="Chat" actions={switcher} />
      <div className={s.shell}>
        <ConvosSidebar />
        <ChatColumn state={state} />
      </div>
    </>
  );
}
