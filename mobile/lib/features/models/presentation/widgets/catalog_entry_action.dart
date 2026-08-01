import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/catalog_entry.dart';
import '../../data/device_capabilities.dart';
import '../../data/download_progress.dart';
import '../../data/runnability.dart';
import '../providers/catalog_download_controller.dart';
import 'download_guard.dart';

class CatalogEntryAction extends ConsumerWidget {
  const CatalogEntryAction({super.key, required this.entry});

  final CatalogEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installed = ref.watch(entryInstalledProvider(entry));
    final progress = ref.watch(
      catalogDownloadControllerProvider.select((s) => s[entry.filename]),
    );
    final notifier = ref.read(catalogDownloadControllerProvider.notifier);
    final ramGb = ref.watch(deviceRamGbProvider).value;

    if (installed) {
      return const _StatusChip(icon: Icons.check_circle, label: 'Installed');
    }
    if (entry.url.isEmpty || entry.filename.isEmpty) {
      return OutlinedButton.icon(
        onPressed: () => context.go('/models/catalog-detail', extra: entry),
        icon: const Icon(Icons.folder_open_outlined, size: 18),
        label: const Text('Choose file'),
      );
    }
    if (progress == null) {
      return FilledButton.tonalIcon(
        onPressed: () => _onDownload(context, notifier, ramGb),
        icon: const Icon(Icons.download_outlined, size: 18),
        label: const Text('Download'),
      );
    }
    return switch (progress.phase) {
      DownloadPhase.downloading => _Progress(
          fraction: progress.fraction,
          onCancel: () => notifier.cancel(entry.filename),
        ),
      DownloadPhase.verifying =>
        const _StatusChip(icon: Icons.shield_outlined, label: 'Verifying…'),
      DownloadPhase.done =>
        const _StatusChip(icon: Icons.check_circle, label: 'Installed'),
      DownloadPhase.failed => OutlinedButton.icon(
          onPressed: () => notifier.start(entry),
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Retry'),
        ),
    };
  }

  Future<void> _onDownload(
    BuildContext context,
    CatalogDownloadController notifier,
    double? ramGb,
  ) async {
    if (ramGb == null) {
      notifier.start(entry);
      return;
    }
    final r = runnabilityFor(entry, ramGb);
    if (r.level == Runnability.tooLarge) {
      final ok = await confirmTooLargeDownload(context, r.neededGb, ramGb);
      if (ok != true) return;
    } else if (r.level == Runnability.tight) {
      warnTightDownload(context, r.neededGb);
    }
    notifier.start(entry);
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.fraction, required this.onCancel});

  final double fraction;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: fraction == 0 ? null : fraction,
            ),
          ),
          const SizedBox(width: 8),
          Text('${(fraction * 100).round()}%'),
          IconButton(
            tooltip: 'Cancel',
            onPressed: onCancel,
            icon: const Icon(Icons.close, size: 18),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: cs.primary),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: cs.primary)),
      ],
    );
  }
}
