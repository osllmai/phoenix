import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'model_providers.dart';

part 'model_filters.g.dart';

/// Catalog search query.
@riverpod
class ModelQuery extends _$ModelQuery {
  @override
  String build() => '';
  void set(String v) => state = v;
}

/// Favorites-only filter toggle.
@riverpod
class ModelFavOnly extends _$ModelFavOnly {
  @override
  bool build() => false;
  void set(bool v) => state = v;
}

/// Catalog sort order.
@riverpod
class ModelSortPref extends _$ModelSortPref {
  @override
  ModelSort build() => ModelSort.recent;
  void set(ModelSort v) => state = v;
}
