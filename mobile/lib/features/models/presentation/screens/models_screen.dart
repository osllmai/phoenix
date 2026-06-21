import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/model_providers.dart';
import '../widgets/active_model_banner.dart';
import '../widgets/model_loading_skeleton.dart';
import '../widgets/drop_import.dart';
import '../widgets/model_tile.dart';
import '../widgets/models_empty_state.dart';
import '../widgets/models_toolbar.dart';

/// Catalog hub: lists installed local models with every state — loading
/// skeleton, empty/first-run zero-state, error+retry, and the loaded list.
class ModelsScreen extends ConsumerWidget {
  const ModelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final models = ref.watch(modelsControllerProvider);
    final active = ref.watch(activeModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local models'),
        actions: [
          IconButton(
            tooltip: 'Browse models',
            onPressed: () => context.go('/models/browse'),
            icon: const Icon(Icons.travel_explore),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/models/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add .gguf'),
      ),
      body: DropImport(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: models.when(
            loading: () => const ModelLoadingSkeleton(key: ValueKey('loading')),
            error: (e, _) => _ErrorState(
              key: const ValueKey('error'),
              message: '$e',
              onRetry: () => ref.invalidate(modelsControllerProvider),
            ),
            data: (list) {
              if (list.isEmpty) {
                return ModelsEmptyState(
                  key: const ValueKey('empty'),
                  icon: Icons.dns_outlined,
                  title: 'No models yet',
                  message:
                      'Add a .gguf file you already have on disk to start '
                      'running models entirely on-device — no cloud, no API keys.',
                  ctaLabel: 'Add .gguf file',
                  onCta: () => context.go('/models/add'),
                );
              }
              final filtered = applyModelFilters(
                list,
                query: ref.watch(modelQueryProvider),
                favOnly: ref.watch(modelFavOnlyProvider),
                sort: ref.watch(modelSortPrefProvider),
              );
              return Column(
                key: const ValueKey('data'),
                children: [
                  const ModelsToolbar(),
                  if (active != null) ActiveModelBanner(model: active),
                  Expanded(
                    child: filtered.isEmpty
                        ? const Center(
                            child: Text('No models match your filters.'),
                          )
                        : ListView(
                            children: [
                              for (final m in filtered)
                                ModelTile(
                                  model: m,
                                  onOpen: () =>
                                      context.go('/models/detail', extra: m),
                                ),
                            ],
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 56, color: cs.error),
            const SizedBox(height: 12),
            Text(
              "Couldn't load your models",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
