import 'package:flutter/material.dart';

import '../../../data/providers_stub.dart';
import 'conn_pill.dart';

/// The IndoxHub gateway card: one key, all providers. Shows credits when
/// connected; an error box + retry actions when unreachable / denied.
class GatewayCard extends StatelessWidget {
  const GatewayCard({super.key, required this.info});

  final GatewayInfo info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final ok = info.status == ProvStatus.connected;
    final green = const Color(0xFF6FCF97);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ok ? green : scheme.error),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _icon(scheme, ok),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Flexible(
                        child: Text('IndoxHub gateway',
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                      ),
                      if (ok) ...[
                        const SizedBox(width: 8),
                        _defaultTag(scheme),
                      ],
                    ]),
                    const SizedBox(height: 2),
                    Text('Connect once — reach every provider through IndoxHub.',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
              ConnPill(
                  label: ok ? 'Connected' : 'Unreachable',
                  color: ok ? green : scheme.error),
            ],
          ),
          const SizedBox(height: 16),
          if (ok) _credits(theme, scheme) else _errorBody(theme, scheme),
        ],
      ),
    );
  }

  Widget _icon(ColorScheme scheme, bool ok) => Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: ok ? scheme.primaryContainer : scheme.errorContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.alt_route, color: scheme.onPrimaryContainer),
      );

  Widget _defaultTag(ColorScheme scheme) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        decoration: BoxDecoration(
          color: scheme.primaryContainer,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: scheme.primary),
        ),
        child: Text('Default',
            style: TextStyle(
                color: scheme.onPrimaryContainer,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
      );

  Widget _credits(ThemeData theme, ColorScheme scheme) {
    final usage = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${(info.usedPct * 100).round()}% used',
            style: theme.textTheme.labelSmall
                ?.copyWith(color: scheme.onSurfaceVariant)),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(value: info.usedPct, minHeight: 6),
        ),
      ],
    );
    final topUp = OutlinedButton(onPressed: () {}, child: const Text('Top up'));
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final stats = Row(children: [
            _stat(theme, scheme, 'Credits remaining', info.credits),
            const SizedBox(width: 20),
            _stat(theme, scheme, 'Used this month', info.usedMonth),
          ]);
          if (c.maxWidth < 420) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                stats,
                const SizedBox(height: 12),
                Row(children: [Expanded(child: usage), const SizedBox(width: 16), topUp]),
              ],
            );
          }
          return Row(children: [
            stats,
            const SizedBox(width: 20),
            Expanded(child: usage),
            const SizedBox(width: 16),
            topUp,
          ]);
        },
      ),
    );
  }

  Widget _stat(ThemeData theme, ColorScheme scheme, String label, String val) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 2),
          Text(val,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      );

  Widget _errorBody(ThemeData theme, ColorScheme scheme) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: scheme.errorContainer,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: scheme.error),
            ),
            child: Text(info.error ?? '',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: scheme.onErrorContainer, height: 1.35)),
          ),
          const SizedBox(height: 12),
          Row(children: [
            FilledButton(onPressed: () {}, child: const Text('Retry connection')),
          ]),
        ],
      );
}
