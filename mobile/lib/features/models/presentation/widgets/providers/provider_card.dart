import 'package:flutter/material.dart';

import '../../../data/providers_stub.dart';
import '../../../../../app/status_colors.dart';

/// One provider row as a touch card: identity + enable toggle, status/key-kind,
/// the masked key, and per-card actions (varies by connection status).
class ProviderCard extends StatelessWidget {
  const ProviderCard({super.key, required this.p});

  final ProviderEntry p;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dim = p.status == ProvStatus.disabled || p.status == ProvStatus.notConnected;
    final isErr = p.status == ProvStatus.testFailed || p.status == ProvStatus.denied;

    return Opacity(
      opacity: dim ? 0.62 : 1,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isErr ? scheme.errorContainer : theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isErr ? scheme.error : scheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                      color: toneColor(p.tone, scheme), shape: BoxShape.circle)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text(p.endpoint,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Switch(value: p.enabled, onChanged: dim ? null : (_) {}),
            ]),
            const SizedBox(height: 10),
            _meta(theme, scheme),
            if (p.maskedKey.isNotEmpty || p.keyKind == KeyKind.gateway ||
                p.keyKind == KeyKind.local) ...[
              const SizedBox(height: 8),
              _keyCell(theme, scheme),
            ],
            if (p.errorMsg != null) ...[
              const SizedBox(height: 8),
              _errChip(theme, scheme),
            ],
            const SizedBox(height: 12),
            _actions(scheme),
          ],
        ),
      ),
    );
  }

  Widget _meta(ThemeData theme, ColorScheme scheme) {
    final green = StatusColors.secure;
    final (statusText, statusColor) = switch (p.status) {
      ProvStatus.connected => ('● Connected', green),
      ProvStatus.disabled => ('○ Disabled', scheme.onSurfaceVariant),
      ProvStatus.notConnected => ('○ Not connected', scheme.onSurfaceVariant),
      ProvStatus.testFailed => ('✕ Test failed', scheme.error),
      ProvStatus.denied => ('✕ Denied · 401', scheme.error),
    };
    return Wrap(
      spacing: 10,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(statusText,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: statusColor, fontWeight: FontWeight.w500)),
        if (p.keyKind != KeyKind.none) _keyBadge(theme, scheme),
        if (p.models > 0)
          Text('${p.models} models',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _keyBadge(ThemeData theme, ColorScheme scheme) {
    final (label, color) = switch (p.keyKind) {
      KeyKind.byok => ('BYOK', scheme.tertiary),
      KeyKind.gateway => ('IndoxHub', scheme.primary),
      KeyKind.local => ('Local network', StatusColors.secure),
      KeyKind.none => ('', scheme.outline),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  Widget _keyCell(ThemeData theme, ColorScheme scheme) {
    final muted = p.keyKind == KeyKind.gateway
        ? 'via gateway — no key needed'
        : p.keyKind == KeyKind.local
            ? 'no key — local endpoint'
            : null;
    if (muted != null) {
      return Text(muted,
          style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant, fontStyle: FontStyle.italic));
    }
    return Row(children: [
      Flexible(
        child: Text(p.maskedKey,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace', color: scheme.onSurface)),
      ),
      const SizedBox(width: 8),
      Icon(Icons.visibility_outlined, size: 16, color: scheme.onSurfaceVariant),
      const SizedBox(width: 8),
      Icon(Icons.copy_outlined, size: 15, color: scheme.onSurfaceVariant),
    ]);
  }

  Widget _errChip(ThemeData theme, ColorScheme scheme) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: scheme.error),
        ),
        child: Text(p.errorMsg!,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: scheme.onErrorContainer)),
      );

  Widget _actions(ColorScheme scheme) {
    if (p.status == ProvStatus.notConnected) {
      return const OverflowBar(
        spacing: 8,
        overflowSpacing: 8,
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(onPressed: _noop, child: Text('+ Add key')),
          OutlinedButton(onPressed: _noop, child: Text('Connect')),
        ],
      );
    }
    return OverflowBar(
      spacing: 8,
      overflowSpacing: 8,
      alignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton(onPressed: _noop, child: const Text('Test')),
        OutlinedButton(onPressed: _noop, child: const Text('Set default')),
        OutlinedButton(
            onPressed: _noop,
            style: OutlinedButton.styleFrom(foregroundColor: scheme.error),
            child: const Text('Remove')),
      ],
    );
  }
}

void _noop() {}
