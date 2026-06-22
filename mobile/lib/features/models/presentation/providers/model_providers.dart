import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:phoenix_core/phoenix_core.dart';

import '../../../../core/ai/engine_provider.dart';

export 'model_filters.dart';
export 'models_controller.dart';
export 'selection_providers.dart';

/// Model persistence. Overridden in `main()` with the SQLite impl; defaults to
/// in-memory for tests/previews.
final modelRepositoryProvider = Provider<ModelRepository>((ref) {
  return InMemoryModelRepository();
});

final modelManagerProvider = Provider<ModelManager>((ref) {
  return ModelManager(
    engine: ref.watch(inferenceEngineProvider),
    repository: ref.watch(modelRepositoryProvider),
  );
});

enum ModelSort { recent, name, favorites }

/// Applies the active search query, favorites filter and sort to a model list.
List<AiModel> applyModelFilters(
  List<AiModel> list, {
  required String query,
  required bool favOnly,
  required ModelSort sort,
}) {
  final q = query.trim().toLowerCase();
  final out = list.where((m) {
    if (favOnly && !m.isLiked) return false;
    if (q.isEmpty) return true;
    return m.name.toLowerCase().contains(q) ||
        (m.key ?? '').toLowerCase().contains(q);
  }).toList();
  switch (sort) {
    case ModelSort.name:
      out.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    case ModelSort.favorites:
      out.sort((a, b) => (b.isLiked ? 1 : 0).compareTo(a.isLiked ? 1 : 0));
    case ModelSort.recent:
      break;
  }
  return out;
}
