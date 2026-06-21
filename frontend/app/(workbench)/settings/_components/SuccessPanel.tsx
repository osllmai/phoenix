'use client';

import { useState } from 'react';

import SettingsNav from './SettingsNav';
import { Appearance, General, ModelsInference } from './SectionsTop';
import { About, Backend, Privacy, Storage } from './SectionsBottom';
import { useSettingsForm } from './useSettingsForm';
import { SETTINGS_PATH } from '../sample';
import s from '../page.module.css';

export default function SuccessPanel() {
  const f = useSettingsForm();
  const [active, setActive] = useState('appearance');
  const [query, setQuery] = useState('');

  const select = (id: string) => {
    setActive(id);
    document.getElementById(id)?.scrollIntoView({ behavior: 'smooth', block: 'start' });
  };

  return (
    <div className={s.shell}>
      <SettingsNav
        active={active}
        onSelect={select}
        query={query}
        onQuery={setQuery}
        foot="All changes saved locally"
      />
      <div className={s.panel}>
        <div className={s.inner}>
          <div className={`${s.banner} ${s.success}`}>
            <span className={s.bannerIcon}>✓</span>
            <div className={s.bannerBody}>
              <strong>Settings loaded</strong>
              All preferences read from <code className={s.code}>{SETTINGS_PATH}</code>.
            </div>
          </div>
          <Appearance f={f} />
          <General f={f} />
          <ModelsInference f={f} />
          <Privacy f={f} />
          <Storage />
          <Backend f={f} />
          <About />
        </div>
      </div>
    </div>
  );
}
