import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phoenix_core/phoenix_core.dart';

import '../data/storage_usage.dart';
import 'setting_field.dart';
import 'settings_actions.dart';

class StorageSection extends ConsumerWidget {
  const StorageSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final usage = ref.watch(storageUsageProvider).value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingGroup(
          title: 'Disk usage',
          children: [
            if (usage == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Calculating…'),
              )
            else ...[
              for (final e in usage.entries)
                _Meter(entry: e, total: usage.total, scheme: scheme),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: Theme.of(context).textTheme.bodyMedium),
                    Text(formatBytes(usage.total),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600, color: scheme.primary)),
                  ],
                ),
              ),
            ],
          ],
        ),
        SettingGroup(
          children: [
            SettingField(
              name: 'Installed models',
              description: 'Manage downloaded models',
              control: OutlinedButton(
                onPressed: () => context.go('/models'),
                child: const Text('Manage…'),
              ),
            ),
            SettingField(
              name: 'Clear cache',
              description: 'Delete cached & temporary files (models kept)',
              control: OutlinedButton(
                style: OutlinedButton.styleFrom(foregroundColor: scheme.error),
                onPressed: () async {
                  final freed = await ref.read(cacheCleanerProvider.notifier).clear();
                  ref.invalidate(storageUsageProvider);
                  if (context.mounted) {
                    notify(context, 'Cleared ${formatBytes(freed)}');
                  }
                },
                child: const Text('Clear cache…'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Meter extends StatelessWidget {
  const _Meter({required this.entry, required this.total, required this.scheme});

  final StorageEntry entry;
  final int total;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(entry.label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: total > 0 ? entry.bytes / total : 0,
                minHeight: 8,
                backgroundColor: scheme.surfaceContainerHighest,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            formatBytes(entry.bytes),
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
