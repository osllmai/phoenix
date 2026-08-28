import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../data/online_catalog_stub.dart';
import '../../../../../app/status_colors.dart';

const _green = StatusColors.online;

/// The Online page header: title, credits balance, a connection-state pill and
/// a "Manage keys" action.
class OnlineHeader extends StatelessWidget {
  const OnlineHeader({super.key, required this.state, this.onState});

  final OnlineState state;
  final ValueChanged<OnlineState>? onState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('Online · IndoxHub',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (state == OnlineState.success || state == OnlineState.empty)
                _credits(theme),
              _connPill(theme),
              if (state != OnlineState.firstRun)
                OutlinedButton(
                    onPressed: () {},
                    child: Text(state == OnlineState.denied
                        ? 'Update key'
                        : 'Manage keys')),
              if (onState != null && kDebugMode)
                PopupMenuButton<OnlineState>(
                  tooltip: 'Preview state',
                  icon: const Icon(Icons.more_vert, size: 18),
                  onSelected: onState,
                  itemBuilder: (_) => [
                    for (final s in OnlineState.values)
                      PopupMenuItem(value: s, child: Text(s.name)),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _credits(ThemeData theme) {
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text('Credits ',
            style: theme.textTheme.labelSmall
                ?.copyWith(color: scheme.onSurfaceVariant)),
        Text(r'$42.18',
            style: theme.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        Container(
          width: 56,
          height: 5,
          decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(999)),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.64,
            child: Container(
                decoration: BoxDecoration(
                    color: _green, borderRadius: BorderRadius.circular(999))),
          ),
        ),
      ]),
    );
  }

  Widget _connPill(ThemeData theme) {
    final scheme = theme.colorScheme;
    final (label, dot, bg, fg) = switch (state) {
      OnlineState.firstRun => ('Not connected', scheme.outline,
          scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
      OnlineState.loading => ('Connecting…', StatusColors.warning,
          scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
      OnlineState.error => ('Gateway unreachable', scheme.error,
          scheme.errorContainer, scheme.onErrorContainer),
      OnlineState.denied => ('401 Unauthorized', scheme.error,
          scheme.errorContainer, scheme.onErrorContainer),
      _ => ('Connected', _green, _green.withValues(alpha: 0.16), _green),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label,
            style: theme.textTheme.labelMedium
                ?.copyWith(color: fg, fontWeight: FontWeight.w500)),
      ]),
    );
  }
}
