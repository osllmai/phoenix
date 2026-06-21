import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/welcome_content.dart';
import '../../providers/welcome_controller.dart';
import '../parts/telemetry_toggle.dart';

/// Step 4 — ready: confirmation, capability chips, the installing-model banner
/// and a final telemetry opt-in.
class ReadyStep extends ConsumerWidget {
  const ReadyStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(welcomeControllerProvider);
    final controller = ref.read(welcomeControllerProvider.notifier);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final installing = state.progress > 0 && state.progress < 1.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [for (final c in readyChips) _chip(theme, c)],
        ),
        const SizedBox(height: 20),
        if (installing) _installBanner(theme, state.percent, state.progress),
        if (installing) const SizedBox(height: 16),
        TelemetryToggle(value: state.telemetry, onChanged: controller.toggleTelemetry),
        const SizedBox(height: 12),
        Text('🔒 Inference runs on-device · conversations stay in local SQLite · '
            'no network required.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: scheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _chip(ThemeData theme, String text) {
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.outline),
      ),
      child: Text(text,
          style: theme.textTheme.labelSmall
              ?.copyWith(color: scheme.onPrimaryContainer)),
    );
  }

  Widget _installBanner(ThemeData theme, int percent, double progress) {
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.onPrimaryContainer),
      ),
      child: Row(
        children: [
          Icon(Icons.download_outlined, size: 18, color: scheme.onPrimaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Model installing… $percent%',
                    style: theme.textTheme.titleSmall?.copyWith(
                        color: scheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text('finishes in the background',
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(value: progress, minHeight: 6),
            ),
          ),
        ],
      ),
    );
  }
}
