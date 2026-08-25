'use client';

import { useEffect, useState } from 'react';

import { MockStateSwitcher } from '@/app/components/dev/MockStateSwitcher';
import { PageHeader } from '@/app/components/ui';

import ChatColumn from './_components/ChatColumn';
import ConvosSidebar from './_components/ConvosSidebar';
import { CHAT_STATES, type ChatState } from './_components/data';
import s from './page.module.css';

const COLLAPSE_KEY = 'phoenix.chat.convosCollapsed';
const TABLET_MAX = 1024;

function readCollapsed(): boolean {
  if (typeof window === 'undefined') return false;
  const stored = window.localStorage.getItem(COLLAPSE_KEY);
  if (stored !== null) return stored === 'true';
  return window.innerWidth <= TABLET_MAX;
}

export default function ChatPage() {
  const [state, setState] = useState<ChatState>('success');
  const [collapsed, setCollapsed] = useState(false);

  useEffect(() => setCollapsed(readCollapsed()), []);

  const toggle = () => {
    setCollapsed((prev) => {
      const next = !prev;
      window.localStorage.setItem(COLLAPSE_KEY, String(next));
      return next;
    });
  };

  const switcher = (
    <MockStateSwitcher
      states={CHAT_STATES}
      value={state}
      onChange={setState}
      className={s.switcher}
      activeClassName={s.switcherOn}
    />
  );

  return (
    <>
      <PageHeader title="Chat" actions={switcher} />
      <div className={s.shell}>
        <ConvosSidebar collapsed={collapsed} onToggle={toggle} />
        <ChatColumn state={state} />
      </div>
    </>
  );
}
