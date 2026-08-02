'use client';

import { Button } from '@/app/components/ui';

import {
  ACCELERATORS,
  ACCENTS,
  CHAT_MODELS,
  CONTEXT_LENGTHS,
  DEFAULT_MODELS,
  EMBED_MODELS,
  LANGUAGES,
  STARTUP_VIEWS,
} from '../sample';
import type { SettingsForm } from './useSettingsForm';
import { Block, Field, Range, RadioPills, Select, Toggle } from './fields';
import { FontPicker } from './FontPicker';
import { FontNotice } from './FontNotice';
import { ThemeGallery } from './ThemeGallery';
import s from '../page.module.css';
import fp from './fontPicker.module.css';

export function Appearance({ f }: { f: SettingsForm }) {
  return (
    <>
      <h2 className={s.sectionTitle} id="appearance">Appearance</h2>
      <p className={s.sub}>Theme, type scale, and accent.</p>
      <Block>
        <Field name="Theme" desc="Warm-charcoal dark, light, or follow OS">
          <RadioPills name="theme" value={f.theme} onChange={f.setTheme} options={['Dark', 'Light', 'System']} />
        </Field>
        <Field name="Font" desc="Typeface for UI and prose">
          <div className={fp.fontField}>
            <FontPicker value={f.fontFamily} onChange={f.setFontFamily} />
            <FontNotice />
          </div>
        </Field>
        <Field name="Font size" desc="Base UI and prose scale">
          <Range value={f.fontSize} onChange={f.setFontSize} min={12} max={20} unit="px" />
        </Field>
        <Field name="Accent color" desc="Highlights and interactive elements">
          <div className={s.swatchRow}>
            {ACCENTS.map((a) => (
              <button
                key={a.id}
                type="button"
                title={a.label}
                aria-label={a.label}
                className={`${s.swatch} ${f.accent === a.id ? s.sel : ''}`}
                onClick={() => f.setAccent(a.id)}
              >
                <span className={s.swatchDot} style={{ background: `var(${a.varName})` }} />
              </button>
            ))}
          </div>
        </Field>
        <Field name="Color theme" desc="Shared palette — re-themes the whole site">
          <ThemeGallery value={f.colorTheme} onChange={f.setColorTheme} />
        </Field>
      </Block>
    </>
  );
}

export function General({ f }: { f: SettingsForm }) {
  return (
    <>
      <h2 className={`${s.sectionTitle} ${s.sectionTitleGap}`} id="general">General</h2>
      <Block>
        <Field name="Language" desc="Interface language">
          <Select value={f.language} onChange={f.setLanguage} options={LANGUAGES} />
        </Field>
        <Field name="On startup" desc="What Phoenix opens to">
          <Select value={f.startup} onChange={f.setStartup} options={STARTUP_VIEWS} />
        </Field>
        <Field name="Default model" desc="Loaded on startup unless overridden per chat">
          <Select value={f.defaultModel} onChange={f.setDefaultModel} options={DEFAULT_MODELS} />
        </Field>
        <Field name="Launch at login" desc="Start Phoenix when you sign in">
          <Toggle on={f.launchAtLogin} onChange={f.setLaunchAtLogin} />
        </Field>
      </Block>
    </>
  );
}

export function ModelsInference({ f }: { f: SettingsForm }) {
  return (
    <>
      <h2 className={`${s.sectionTitle} ${s.sectionTitleGap}`} id="models">Models &amp; Inference</h2>
      <p className={s.sub}>Engine runs on-device via llama.cpp.</p>
      <Block head="Models">
        <Field name="Default chat model" desc="GGUF used for conversation">
          <Select value={f.chatModel} onChange={f.setChatModel} options={CHAT_MODELS} />
        </Field>
        <Field name="Default embedding model" desc="Used for search & document RAG">
          <Select value={f.embedModel} onChange={f.setEmbedModel} options={EMBED_MODELS} />
        </Field>
      </Block>
      <Block head="Inference">
        <Field name="Context length" desc="nCtx — max token window per session">
          <Select value={f.contextLength} onChange={f.setContextLength} options={CONTEXT_LENGTHS} />
        </Field>
        <Field name="GPU / accelerator" desc="Device for layer offload">
          <Select value={f.accelerator} onChange={f.setAccelerator} options={ACCELERATORS} />
        </Field>
        <Field name="GPU layers" desc="numberOfGpuLayers — 0 = CPU only">
          <Range value={f.gpuLayers} onChange={f.setGpuLayers} min={0} max={99} />
        </Field>
        <Field name="CPU threads" desc="nThread — parallel decode threads">
          <Range value={f.cpuThreads} onChange={f.setCpuThreads} min={1} max={32} />
        </Field>
      </Block>
    </>
  );
}

export function modelsEmptyActions() {
  return (
    <>
      <Button>＋ Browse model catalog</Button>
      <Button variant="ghost">Import GGUF file…</Button>
    </>
  );
}
