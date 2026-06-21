import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../data/hf_repository.dart';
import '../../data/remote_catalog_repository.dart';
import '../providers/browse_query.dart';
import '../widgets/browse_header.dart';
import '../widgets/browse_results.dart';

class ModelsBrowseScreen extends ConsumerWidget {
  const ModelsBrowseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final source = ref.watch(browseSourceSelProvider);
    final query = ref.watch(browseSearchProvider);
    final async = source == BrowseSource.huggingFace
        ? ref.watch(hfSearchProvider(query))
        : ref.watch(remoteCatalogProvider);
    final wide = !formFactorOf(context).isPhone;

    return Scaffold(
      appBar: AppBar(title: const Text('Browse models')),
      body: Column(
        children: [
          const _SourceToggle(),
          Expanded(
            child: async.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => _Error(
                message: '$e',
                onRetry: () => _invalidate(ref, source, query),
              ),
              data: (entries) => _Loaded(entries: entries, wide: wide),
            ),
          ),
        ],
      ),
    );
  }

  void _invalidate(WidgetRef ref, BrowseSource source, String query) {
    if (source == BrowseSource.huggingFace) {
      ref.invalidate(hfSearchProvider(query));
    } else {
      ref.invalidate(remoteCatalogProvider);
    }
  }
}

class _SourceToggle extends ConsumerWidget {
  const _SourceToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final source = ref.watch(browseSourceSelProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: SegmentedButton<BrowseSource>(
        showSelectedIcon: false,
        segments: const [
          ButtonSegment(
            value: BrowseSource.catalog,
            icon: Icon(Icons.inventory_2_outlined),
            label: Text('Catalog'),
          ),
          ButtonSegment(
            value: BrowseSource.huggingFace,
            icon: Icon(Icons.cloud_outlined),
            label: Text('Hugging Face'),
          ),
        ],
        selected: {source},
        onSelectionChanged: (s) =>
            ref.read(browseSourceSelProvider.notifier).set(s.first),
      ),
    );
  }
}

class _Loaded extends ConsumerWidget {
  const _Loaded({required this.entries, required this.wide});

  final List entries;
  final bool wide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(browseSearchProvider);
    final sort = ref.watch(browseSortProvider);
    final ascending = ref.watch(browseAscendingProvider);
    final category = ref.watch(browseCategorySelProvider);
    final visible = filterSortEntries(
      entries.cast(),
      query,
      sort,
      ascending,
      category: category,
    );
    return Column(
      children: [
        BrowseHeader(count: visible.length),
        Expanded(child: BrowseResults(entries: visible, wide: wide)),
      ],
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.message, required this.onRetry});

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
            Text("Couldn't load the catalog",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(color: cs.onSurfaceVariant)),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
