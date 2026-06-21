'use client';

import { useState } from 'react';

import type { Repo, Sibling } from './sampleData';
import s from '../page.module.css';

const CAP_CLASS: Record<Repo['capability'], string> = {
  text: s.capText,
  code: s.capCode,
  vision: s.capVision,
  audio: s.capAudio,
  embed: s.capEmbed,
};

const RUN_CLASS: Record<Repo['runnability'], string> = {
  ok: s.runOk,
  tight: s.runTight,
  big: s.runBig,
};

function DownloadingRow({ sib }: { sib: Sibling }) {
  const dl = sib.download!;
  return (
    <div className={s.dlRow}>
      <div className={s.dlTop}>
        <span className={s.dlFilename}>{sib.filename}</span>
        <span className={s.dlSpeed}>{dl.speed}</span>
        <button type="button" className={s.btnCancel}>
          Cancel
        </button>
      </div>
      <div className={s.dlUrl}>{dl.url}</div>
      <div className={s.progressTrack}>
        <div className={s.progressFill} style={{ width: `${dl.percent}%` }} />
      </div>
    </div>
  );
}

function SiblingRow({ sib }: { sib: Sibling }) {
  const [checked, setChecked] = useState(Boolean(sib.selected));
  const done = sib.state === 'downloaded';
  return (
    <div className={s.siblingRow}>
      <input
        className={s.sibCheck}
        type="checkbox"
        checked={done ? true : checked}
        disabled={done}
        onChange={(e) => setChecked(e.target.checked)}
        aria-label={done ? 'Already downloaded' : 'Select for download'}
      />
      <span className={s.sibFilename}>{sib.filename}</span>
      <span className={`${s.quant} ${sib.recommended ? s.quantRec : ''}`}>{sib.quant}</span>
      <span className={s.sibSize}>{sib.size}</span>
      {done ? (
        <button type="button" className={`${s.btnDl} ${s.btnDone}`} disabled>
          Downloaded ✓
        </button>
      ) : (
        <button type="button" className={`${s.btnDl} ${s.btnDownload}`}>
          Download
        </button>
      )}
    </div>
  );
}

export default function RepoCard({ repo }: { repo: Repo }) {
  const [open, setOpen] = useState(Boolean(repo.defaultOpen));
  return (
    <div className={`${s.repoCard} ${open ? s.repoOpen : ''}`}>
      <div className={s.repoHeader} role="button" tabIndex={0} onClick={() => setOpen((v) => !v)}>
        <div className={s.repoIcon}>🤗</div>
        <div className={s.repoMeta}>
          <div className={s.repoId}>{repo.id}</div>
          <div className={s.repoAuthor}>
            by {repo.author} · <span className={s.quants}>{repo.variants}</span>
          </div>
        </div>
        <div className={s.repoStats}>
          <span className={s.stat}>
            ⬇ <b>{repo.downloads}</b>
          </span>
          <span className={s.stat}>
            ♥ <b>{repo.likes}</b>
          </span>
          <span className={`${s.tag} ${CAP_CLASS[repo.capability]}`}>{repo.capabilityLabel}</span>
          <span className={`${s.tag} ${RUN_CLASS[repo.runnability]}`}>{repo.runnabilityLabel}</span>
          <span className={`${s.tag} ${s.tagSize}`}>{repo.size}</span>
          <span className={`${s.tag} ${s.tagRam}`}>{repo.ram}</span>
          {repo.gpu && <span className={`${s.tag} ${s.tagGpu}`}>⚡ GPU</span>}
          <span className={`${s.tag} ${s.tagLicense}`}>{repo.license}</span>
        </div>
        <span className={s.chevron}>▶</span>
      </div>

      {open && repo.siblings.length > 0 && (
        <div className={s.siblingList}>
          {repo.gguf.length > 0 && (
            <div className={s.ggufMeta}>
              {repo.gguf.map((g) => (
                <span
                  key={g.label}
                  className={`${s.ggufBadge} ${g.kind ? s[`badge${g.kind[0].toUpperCase()}${g.kind.slice(1)}`] : ''}`}
                >
                  {g.label}
                </span>
              ))}
            </div>
          )}
          {repo.siblings.map((sib) =>
            sib.state === 'downloading' ? (
              <DownloadingRow key={sib.filename} sib={sib} />
            ) : (
              <SiblingRow key={sib.filename} sib={sib} />
            ),
          )}
        </div>
      )}
    </div>
  );
}
