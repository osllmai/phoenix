import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/marketplace_controller.dart';
import 'extension_card.dart';
import 'marketplace_empty.dart';

class MarketplaceList extends ConsumerWidget {
  const MarketplaceList({super.key, this.onSelected});

  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(marketplaceCatalogProvider);
    final state = ref.watch(marketplaceControllerProvider);
    final controller = ref.read(marketplaceControllerProvider.notifier);
    final text = Theme.of(context).textTheme;

    return catalog.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Could not load extensions',
              style: text.titleMedium, textAlign: TextAlign.center),
        ),
      ),
      data: (entries) {
        if (entries.isEmpty) {
          return MarketplaceEmpty(
            onClear: () {
              controller
                ..selectCategory(null)
                ..search('');
            },
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            Text('Featured · First-party',
                style: text.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  letterSpacing: 1.2,
                )),
            const SizedBox(height: 8),
            for (final e in entries)
              ExtensionCard(
                entry: e,
                selected: e.slug == state.selectedSlug,
                installing: state.installing.contains(e.slug),
                onTap: () {
                  controller.select(e.slug);
                  onSelected?.call();
                },
                onInstall: () => controller.install(e.slug),
                onUninstall: () => controller.uninstall(e.slug),
              ),
          ],
        );
      },
    );
  }
}
