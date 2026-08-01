'use client';

import { Button } from '@/app/components/ui';

import { DATA_DIR, VERSIONS } from '../sample';
import { copyToClipboard, useFlash } from './actions';
import s from '../page.module.css';

function Flash({ msg }: { msg: string }) {
  return msg ? <span className={s.flash}>{msg}</span> : null;
}

export function RevealButton({ path }: { path: string }) {
  const { msg, flash } = useFlash();
  return (
    <>
      <Button
        variant="ghost"
        onClick={() => copyToClipboard(path).then((ok) => flash(ok ? 'Path copied' : 'Copy failed'))}
      >
        Reveal…
      </Button>
      <Flash msg={msg} />
    </>
  );
}

export function ManageButton() {
  const { msg, flash } = useFlash();
  return (
    <>
      <Button
        variant="ghost"
        onClick={() => copyToClipboard(DATA_DIR).then((ok) => flash(ok ? 'Store path copied' : 'Copy failed'))}
      >
        Manage…
      </Button>
      <Flash msg={msg} />
    </>
  );
}

export function ClearCachesButton() {
  const { msg, flash } = useFlash();
  return (
    <>
      <button type="button" className={s.btnDanger} onClick={() => flash('Cache clearing runs in the desktop app')}>
        Clear caches…
      </button>
      <Flash msg={msg} />
    </>
  );
}

export function AboutActions() {
  const { msg, flash } = useFlash();
  const version = VERSIONS[0]?.value ?? '';
  return (
    <div className={s.actions}>
      <Button onClick={() => flash(`Up to date — Phoenix ${version}`)}>Check for updates</Button>
      <Button variant="ghost" onClick={() => flash('Licenses bundled with the desktop build')}>
        View licenses
      </Button>
      <Button
        variant="ghost"
        onClick={() => copyToClipboard(`${DATA_DIR}/logs`).then((ok) => flash(ok ? 'Log path copied' : 'Copy failed'))}
      >
        Open log folder
      </Button>
      <Flash msg={msg} />
    </div>
  );
}
