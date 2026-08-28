'use client';

/// Design-review affordance for flipping a page between its mock states.
/// Never rendered unless NEXT_PUBLIC_MOCK_STATES=1, so it cannot reach users.
export const mockStatesEnabled = process.env.NEXT_PUBLIC_MOCK_STATES === '1';

export function MockStateSwitcher<T extends string>({
  states,
  value,
  onChange,
  className,
  buttonClassName,
  activeClassName,
}: {
  states: readonly T[];
  value: T;
  onChange: (state: T) => void;
  className?: string;
  buttonClassName?: string;
  activeClassName?: string;
}) {
  if (!mockStatesEnabled) return null;
  return (
    <div className={className}>
      {states.map((state) => (
        <button
          key={state}
          type="button"
          className={[buttonClassName, state === value ? activeClassName : null]
            .filter(Boolean)
            .join(' ')}
          onClick={() => onChange(state)}
        >
          {state}
        </button>
      ))}
    </div>
  );
}
