import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/extensions_repository.dart';
import 'extension_entry.dart';
import 'marketplace_filters.dart';
import 'marketplace_state.dart';

part 'marketplace_controller.g.dart';

@riverpod
class MarketplaceController extends _$MarketplaceController {
  @override
  MarketplaceState build() => const MarketplaceState();

  ExtensionsRepository get _repo => ref.read(extensionsRepositoryProvider);

  void search(String query) =>
      ref.read(marketplaceFiltersProvider.notifier).setQuery(query);

  void selectCategory(ExtensionCategory? category) =>
      ref.read(marketplaceFiltersProvider.notifier).setCategory(category);

  void select(String slug) => state = state.copyWith(selectedSlug: slug);

  Future<void> install(String slug) => _mutate(slug, _repo.install);

  Future<void> uninstall(String slug) => _mutate(slug, _repo.uninstall);

  Future<void> _mutate(
    String slug,
    Future<ExtensionEntry> Function(String) call,
  ) async {
    if (state.installing.contains(slug)) return;
    state = state.copyWith(installing: {...state.installing, slug});
    try {
      await call(slug);
      ref.invalidate(marketplaceCatalogProvider);
    } finally {
      state = state.copyWith(
        installing: state.installing.where((e) => e != slug).toSet(),
      );
    }
  }
}

@riverpod
Future<List<ExtensionEntry>> marketplaceCatalog(Ref ref) async {
  final (category, query) = ref.watch(marketplaceFiltersProvider);
  final repo = ref.watch(extensionsRepositoryProvider);
  return repo.list(
    category: category?.name,
    query: query.trim().isEmpty ? null : query.trim(),
  );
}

@riverpod
ExtensionEntry? selectedExtension(Ref ref) {
  final slug = ref.watch(marketplaceControllerProvider).selectedSlug;
  final catalog = ref.watch(marketplaceCatalogProvider).value;
  if (catalog == null || catalog.isEmpty) return null;
  if (slug == null) return catalog.first;
  for (final e in catalog) {
    if (e.slug == slug) return e;
  }
  return catalog.first;
}
