import 'package:flutter/material.dart';

/// Upgrade path for running a desktop-class [feature] in the cloud (via
/// IndoxHub) without a paired desktop. Placeholder until billing is wired.
Future<void> showSubscribeSheet(BuildContext context, {required String feature}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      final scheme = theme.colorScheme;
      const perks = [
        'Run forecasting & agents in the cloud — any device, no desktop',
        'Pay-as-you-go IndoxHub usage',
        'Your local, on-device features stay free',
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
              Row(children: [
                Icon(Icons.workspace_premium, color: scheme.primary),
                const SizedBox(width: 8),
                Text('Phoenix Pro', style: theme.textTheme.titleLarge),
              ]),
              const SizedBox(height: 6),
              Text(
                '$feature runs on a paired desktop today. Subscribe to run it in '
                'the cloud via IndoxHub — no desktop needed.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              for (final p in perks)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Icon(Icons.check_circle, size: 18, color: scheme.primary),
                    const SizedBox(width: 10),
                    Expanded(child: Text(p, style: theme.textTheme.bodyMedium)),
                  ]),
                ),
              const SizedBox(height: 12),
              Row(children: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Maybe later'),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Register & subscribe'),
                ),
              ]),
              ],
            ),
          ),
        ),
      );
    },
  );
}
