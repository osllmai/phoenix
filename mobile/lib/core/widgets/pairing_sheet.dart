import 'package:flutter/material.dart';

/// How to pair a desktop so this companion device can run desktop-only features
/// (forecasting, agents, server console) on the desktop's backend.
Future<void> showPairingSheet(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      const steps = [
        'Open Phoenix on your desktop (Windows, macOS or Linux), on the same network.',
        'On the desktop: Settings → Devices → Pair a device.',
        'Enter the code shown there, or scan its QR with this device.',
      ];
      return Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text('Pair a desktop', style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                "Run desktop features on your computer's backend from this device.",
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              for (var i = 0; i < steps.length; i++)
                _Step(n: i + 1, text: steps[i]),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Got it'),
                ),
              ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _Step extends StatelessWidget {
  const _Step({required this.n, required this.text});
  final int n;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: scheme.primaryContainer,
          child: Text('$n',
              style: TextStyle(fontSize: 12, color: scheme.onPrimaryContainer)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
      ]),
    );
  }
}
