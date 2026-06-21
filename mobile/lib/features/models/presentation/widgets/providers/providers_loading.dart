import 'package:flutter/material.dart';

/// Loading: gateway + provider connections being tested.
class ProvidersLoading extends StatelessWidget {
  const ProvidersLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Row(
            children: [
              const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2)),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Pinging IndoxHub gateway and verifying credits…',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        for (var i = 0; i < 3; i++) ...[
          _skelRow(scheme),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _skelRow(ColorScheme scheme) => Container(
        height: 64,
        decoration: BoxDecoration(
          color: theme0(scheme),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.outlineVariant),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _bar(scheme, 120),
            const SizedBox(width: 16),
            Expanded(child: _bar(scheme, double.infinity)),
          ],
        ),
      );

  Color theme0(ColorScheme scheme) => scheme.surfaceContainerHighest;

  Widget _bar(ColorScheme scheme, double width) => Container(
        width: width,
        height: 12,
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(4),
        ),
      );
}
