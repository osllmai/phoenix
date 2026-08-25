'use client';

import { useState } from 'react';

import { MockStateSwitcher } from '@/app/components/dev/MockStateSwitcher';
import { Button, CenterState, EmptyState, ErrorState } from '@/app/components/ui';

import ForecastControls from './_components/ForecastControls';
import ForecastHeader from './_components/ForecastHeader';
import ForecastResults from './_components/ForecastResults';
import LoadingView from './_components/LoadingView';
import { SAMPLE_CHECKPOINTS, type FcState } from './_components/sampleData';
import s from './page.module.css';

const STATES: FcState[] = ['success', 'empty', 'first-run', 'loading', 'error', 'denied'];

export default function ForecastingPage() {
  const [state, setState] = useState<FcState>('success');
  const [source, setSource] = useState('upload');
  const [selected, setSelected] = useState('aapl');
  const [toggles, setToggles] = useState<Record<string, boolean>>({
    Quantiles: true,
    Normalize: true,
    Covariates: false,
  });
  const [disc, setDisc] = useState(true);

  const toggle = (key: string) => setToggles((p) => ({ ...p, [key]: !p[key] }));

  return (
    <>
      <MockStateSwitcher
        states={STATES}
        value={state}
        onChange={setState}
        className={s.switcher}
        activeClassName={s.switchOn}
      />

      <ForecastHeader toggles={toggles} onToggle={toggle} />

      <div className={s.jobbar}>
        <span className={s.dot} /> TimesFM 2.5 loaded · PyTorch backend
        <span className={s.qpill}>200M · CPU</span>
        <span className={s.qpill}>Celery job</span>
        <span className={s.grow} />
        <span>
          Forecasting runs on-device as a backend job — separate from the chat (llama.cpp) engine. No
          data leaves the machine.
        </span>
      </div>

      <div className={s.body}>
        {state === 'success' && (
          <div className={s.split}>
            <ForecastControls
              source={source}
              onSource={setSource}
              selected={selected}
              onSelect={setSelected}
              onRun={() => setState('loading')}
            />
            <ForecastResults />
          </div>
        )}

        {state === 'loading' && <LoadingView onCancel={() => setState('success')} />}

        {state === 'empty' && (
          <EmptyState
            icon="📈"
            title="No series loaded"
            description="Drop a CSV or Parquet file with a timestamp and value column, or pick a sample series, to forecast with TimesFM — fully on-device."
            actions={
              <>
                <Button>Upload a series</Button>
                <Button variant="ghost" onClick={() => setState('success')}>
                  Load a sample
                </Button>
              </>
            }
          />
        )}

        {state === 'first-run' && (
          <CenterState
            icon="📥"
            title="Get a TimesFM checkpoint"
            description="Forecasting runs fully on-device as a backend job (PyTorch · CPU). Pick a checkpoint — nothing is sent to the cloud. The chat engine (llama.cpp) is separate and unaffected."
            sub={
              <>
                🔒 Apache-2.0 · checkpoints from Hugging Face (
                <code>google/timesfm-2.5-200m-pytorch</code>), cached under{' '}
                <code>~/phoenix/models/timesfm/</code>.
              </>
            }
          >
            <div className={s.cards}>
              {SAMPLE_CHECKPOINTS.map((c) => (
                <div key={c.name} className={s.modelCard}>
                  <div>
                    <div className={s.mcName}>{c.name}</div>
                    <div className={s.mcMeta}>{c.meta}</div>
                  </div>
                  <Button
                    variant={c.recommended ? 'cta' : 'ghost'}
                    className={s.mcDl}
                    onClick={() => setState('success')}
                  >
                    ⬇ Download
                  </Button>
                </div>
              ))}
            </div>
          </CenterState>
        )}

        {state === 'error' && (
          <ErrorState
            title="Forecast failed"
            heading="The series couldn't be parsed"
            message="TimesFM needs a regular timestamp column and a numeric value column. Gaps are filled to the chosen frequency; non-numeric values are rejected."
            actions={
              <>
                <Button onClick={() => setState('loading')}>↺ Retry</Button>
                <Button variant="ghost">Map columns</Button>
              </>
            }
            sub={
              <span className={s.mono}>
                Job log: <code>timesfm.forecast: expected float, got &apos;N/A&apos; at row 184</code>
              </span>
            }
          />
        )}

        {state === 'denied' && (
          <ErrorState
            icon="🧩"
            variant="warning"
            title="Forecasting backend unavailable"
            heading="The TimesFM backend isn't running"
            message="Forecasting is a backend extension (PyTorch · Celery). This can happen on a companion device with no backend, when the worker is stopped, or if the extension was disabled. Core chat & models stay available."
            actions={
              <>
                <Button>Open in Extensions</Button>
                <Button variant="ghost">Start backend</Button>
              </>
            }
            sub="On mobile, run the forecast against your desktop's backend over the local gateway."
          />
        )}
      </div>

      {disc && (
        <div className={s.disclaimer}>
          <span className={s.di}>⚠</span>
          <span>
            Forecasts are probabilistic estimates from <strong>TimesFM</strong> —{' '}
            <strong>not financial, investment, or trading advice</strong>. Markets are uncertain and
            past patterns don&apos;t guarantee future results; verify independently before acting.
            Connected market data may be delayed and is for informational use only.
          </span>
          <button
            type="button"
            className={s.discX}
            aria-label="Dismiss disclaimer"
            onClick={() => setDisc(false)}
          >
            ×
          </button>
        </div>
      )}
    </>
  );
}
