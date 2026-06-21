'use client';

import { CenterState, ErrorState, Button } from '@/app/components/ui';
import { RECOMMENDED_EXTENSIONS } from './sampleData';
import s from '../page.module.css';

export function EmptyPane({ onClear, onBrowse }: { onClear: () => void; onBrowse: () => void }) {
  return (
    <CenterState
      icon="🔍"
      title="No extensions match"
      description={
        <>Nothing matches “<code>xlsx-magic</code>”. Try a different term, or browse a category.</>
      }
      sub="Phoenix extensions are FeatureModule plugins — you can side-load your own."
    >
      <div className={s.btnrow}>
        <Button variant="ghost" onClick={onClear}>
          Clear search
        </Button>
        <Button onClick={onBrowse}>Browse all</Button>
      </div>
    </CenterState>
  );
}

export function FirstRunPane() {
  return (
    <CenterState
      icon="🧩"
      title="Your Phoenix is lightweight"
      description="The core app is just chat + models (48 MB). Add only the features you need — each installs its backend on demand and frees the space when removed."
      sub="You can install more anytime from this marketplace."
    >
      <div className={s.reco}>
        {RECOMMENDED_EXTENSIONS.map((ext) => (
          <div key={ext.id} className={s.recoCard}>
            <div className={s.extIco}>{ext.icon}</div>
            <div className={s.extName}>{ext.name}</div>
            <div className={s.extDesc}>{ext.description}</div>
            <Button className={s.recoBtn}>Install</Button>
          </div>
        ))}
      </div>
    </CenterState>
  );
}

export function ErrorPane({ onRetry }: { onRetry: () => void }) {
  return (
    <ErrorState
      title="Marketplace unreachable"
      heading="Can’t reach the extension registry"
      message="Phoenix couldn’t fetch the catalog (network offline or registry down). Your installed extensions keep working — only browsing/installing new ones is blocked."
      sub="Already-installed features run fully on-device and don’t need the registry."
      actions={
        <>
          <Button onClick={onRetry}>Retry</Button>
          <Button variant="ghost">Work offline</Button>
        </>
      }
    />
  );
}

export function DeniedPane() {
  return (
    <ErrorState
      icon="🚫"
      variant="warning"
      title="Can’t install this extension"
      heading="Install blocked"
      message="This could be: not enough disk space for the backend image, the extension is disabled by an admin policy, or it needs a sign-in to its provider before installing."
      sub="Core chat & models stay available regardless."
      actions={
        <>
          <Button>Free up space</Button>
          <Button variant="ghost">Review requirements</Button>
        </>
      }
    />
  );
}
