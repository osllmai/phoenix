import s from '../page.module.css';

export default function InstallingPane() {
  return (
    <div className={s.split}>
      <div className={s.browse}>
        <div className={s.groupHd}>Installing</div>
        <div className={`${s.extRow} ${s.extRowSel}`}>
          <div className={s.extIco}>🎙️</div>
          <div className={s.extBody}>
            <div className={s.extName}>Speech · Whisper</div>
            <div className={s.extPub}>Phoenix · downloading…</div>
            <div className={s.progressBar}>
              <div className={s.progressFill} />
            </div>
            <div className={s.extPub}>Pulling Whisper weights — 47 / 75 MB</div>
          </div>
          <button className={s.ghost} type="button">
            Cancel
          </button>
        </div>
        <div className={s.extRow}>
          <div className={s.extIco}>🔎</div>
          <div className={s.extBody}>
            <div className={s.extName}>DeepSearch</div>
            <div className={s.extPub}>✓ Installed</div>
          </div>
          <button className={s.installed} type="button">
            ✓
          </button>
        </div>
      </div>

      <div className={s.detail}>
        <div className={s.detHead}>
          <div className={s.detIco}>🎙️</div>
          <div className={s.extBody}>
            <h2 className={s.detTitle}>Speech · Whisper</h2>
            <div className={s.detMeta}>
              <span>Phoenix</span>
              <span>v0.9.2</span>
              <span>Installing…</span>
            </div>
          </div>
        </div>
        <div className={s.tabBody}>
          <div className={s.ipBox}>
            <h3>Installing Speech · Whisper</h3>
            <p className={s.ipText}>
              Downloading backend weights and registering the feature module. The app stays usable
              meanwhile.
            </p>
            <div className={s.progressBar}>
              <div className={s.progressFill} />
            </div>
            <p className={s.ipText}>62% · 47 / 75 MB · ~20s left</p>
          </div>
          <h3 className={s.detSub}>Steps</h3>
          <ul className={s.steps}>
            <li>✓ Resolve dependencies</li>
            <li>✓ Fetch extension manifest</li>
            <li>⟳ Download Whisper base weights</li>
            <li>• Register FeatureModule + add Speech to rail</li>
          </ul>
        </div>
      </div>
    </div>
  );
}
