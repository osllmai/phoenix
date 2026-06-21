import s from './steps.module.css';

type Props = {
  on: boolean;
  onToggle: () => void;
  label: string;
  help: string;
};

export default function TelemetryToggle({ on, onToggle, label, help }: Props) {
  return (
    <div className={s.toggleRow}>
      <div>
        <div className={s.tlabel}>{label}</div>
        <div className={s.thelp}>{help}</div>
      </div>
      <span style={{ flex: 1 }} />
      <button
        type="button"
        role="switch"
        aria-checked={on}
        aria-label={label}
        className={`${s.switch} ${on ? s.on : ''}`}
        onClick={onToggle}
      />
    </div>
  );
}
