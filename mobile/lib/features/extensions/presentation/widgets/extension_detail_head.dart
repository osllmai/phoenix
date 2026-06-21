import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/extension_entry.dart';
import '../providers/marketplace_controller.dart';
import 'install_button.dart';

class ExtensionDetailHead extends ConsumerWidget {
  const ExtensionDetailHead({super.key, required this.entry, this.onBack});

  final ExtensionEntry entry;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final controller = ref.read(marketplaceControllerProvider.notifier);
    final installing = ref.watch(
      marketplaceControllerProvider
          .select((s) => s.installing.contains(entry.slug)),
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: scheme.outline)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onBack != null)
            IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: scheme.outline),
            ),
            child: Text(entry.icon, style: const TextStyle(fontSize: 30)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.name, style: text.titleLarge),
                const SizedBox(height: 4),
                Text(entry.publisher,
                    style: text.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant)),
                const SizedBox(height: 12),
                InstallButton(
                  entry: entry,
                  installing: installing,
                  onInstall: () => controller.install(entry.slug),
                  onUninstall: () => controller.uninstall(entry.slug),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
