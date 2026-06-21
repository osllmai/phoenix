'use client';

import { useRouter } from 'next/navigation';
import { useState } from 'react';

import ChooseModelStep from './_components/ChooseModelStep';
import { MODELS } from './_components/data';
import ErrorStep from './_components/ErrorStep';
import LoadingStep from './_components/LoadingStep';
import PrivacyStep from './_components/PrivacyStep';
import ReadyStep from './_components/ReadyStep';
import WelcomeStep from './_components/WelcomeStep';
import s from './page.module.css';

type State = 'welcome' | 'choose-model' | 'loading' | 'error' | 'privacy' | 'ready';

export default function WelcomePage() {
  const router = useRouter();
  const [state, setState] = useState<State>('welcome');
  const [model, setModel] = useState(MODELS[0].id);
  const [telemetry, setTelemetry] = useState(false);

  const enterApp = () => router.push('/');
  const toggleTelemetry = () => setTelemetry((v) => !v);

  return (
    <div className={s.stage}>
      {state === 'welcome' && <WelcomeStep onNext={() => setState('choose-model')} />}

      {state === 'choose-model' && (
        <ChooseModelStep
          selected={model}
          onSelect={setModel}
          onBack={() => setState('welcome')}
          onViewDownload={() => setState('loading')}
          onEnter={() => setState('privacy')}
        />
      )}

      {state === 'loading' && <LoadingStep onCancel={() => setState('choose-model')} />}

      {state === 'error' && (
        <ErrorStep
          onChooseAnother={() => setState('choose-model')}
          onRetry={() => setState('loading')}
        />
      )}

      {state === 'privacy' && (
        <PrivacyStep
          telemetry={telemetry}
          onToggle={toggleTelemetry}
          onBack={() => setState('choose-model')}
          onContinue={() => setState('ready')}
        />
      )}

      {state === 'ready' && (
        <ReadyStep
          telemetry={telemetry}
          onToggle={toggleTelemetry}
          onBack={() => setState('choose-model')}
          onEnter={enterApp}
        />
      )}
    </div>
  );
}
