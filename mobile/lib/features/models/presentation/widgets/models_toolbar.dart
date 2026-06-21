import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/model_providers.dart';

/// Catalog toolbar: search · favorites filter · sort.
class ModelsToolbar extends ConsumerWidget {
  const ModelsToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favOnly = ref.watch(modelFavOnlyProvider);
    final sort = ref.watch(modelSortPrefProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                isDense: true,
                prefixIcon: Icon(Icons.search),
                hintText: 'Filter models…',
              ),
              onChanged: (v) => ref.read(modelQueryProvider.notifier).set(v),
            ),
          ),
          const SizedBox(width: 12),
          FilterChip(
            label: const Text('Favorites'),
            avatar: const Icon(Icons.favorite, size: 16),
            selected: favOnly,
            onSelected: (v) => ref.read(modelFavOnlyProvider.notifier).set(v),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<ModelSort>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort',
            initialValue: sort,
            onSelected: (s) => ref.read(modelSortPrefProvider.notifier).set(s),
            itemBuilder: (_) => const [
              PopupMenuItem(value: ModelSort.recent, child: Text('Recent')),
              PopupMenuItem(value: ModelSort.name, child: Text('Name')),
              PopupMenuItem(
                value: ModelSort.favorites,
                child: Text('Favorites first'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
