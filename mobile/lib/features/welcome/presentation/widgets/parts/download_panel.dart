import 'package:flutter/material.dart';

/// Loading state: spinner + label + progress bar while the model downloads.
class DownloadProgress extends StatelessWidget {
  const DownloadProgress({super.key, required this.modelName, required this.progress});

  final String modelName;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      children: [
        Text('Downloading $modelName…',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 20),
        const SizedBox(
            width: 48, height: 48, child: CircularProgressIndicator(strokeWidth: 3)),
        const SizedBox(height: 16),
        Text('Fetching weights · verifying checksum',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: scheme.onSurfaceVariant)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${(progress * 2.0).toStringAsFixed(2)} GB of 2.0 GB',
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: scheme.onSurfaceVariant)),
            Text('${(progress * 100).round()}% · 18 MB/s',
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: scheme.onSurfaceVariant)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(value: progress, minHeight: 10),
        ),
      ],
    );
  }
}

/// Error state: download failed (e.g. not enough disk space).
class DownloadError extends StatelessWidget {
  const DownloadError({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.error),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: scheme.error),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Not enough disk space',
                    style: theme.textTheme.titleSmall?.copyWith(
                        color: scheme.onErrorContainer,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                    'Llama 3.2 3B needs 2.0 GB but only 0.7 GB is free. Free up '
                    'space, choose a smaller model, or retry on a stable network.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
