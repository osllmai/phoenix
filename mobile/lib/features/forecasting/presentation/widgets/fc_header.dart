import 'package:flutter/material.dart';

/// Forecasting top bar (title + model/horizon pickers + pairing chip) and the
/// job-status strip describing the desktop TimesFM backend.
class FcHeader extends StatelessWidget {
  const FcHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('📈 Forecasting', style: theme.textTheme.titleLarge),
            _Picker(label: 'Model', value: 'TimesFM 2.5 (200M)'),
            _Picker(label: 'Horizon', value: '24'),
            Chip(
              avatar: Icon(Icons.circle, size: 10, color: scheme.primary),
              label: const Text('hosted on desktop · paired'),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'TimesFM 2.5 on the paired desktop · PyTorch backend — separate from '
            'the chat (llama.cpp) engine. No data leaves your machine.',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

class _Picker extends StatelessWidget {
  const _Picker({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text('$label  ',
          style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12)),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: scheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(value, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 4),
          Icon(Icons.arrow_drop_down, size: 16, color: scheme.onSurfaceVariant),
        ]),
      ),
    ]);
  }
}
