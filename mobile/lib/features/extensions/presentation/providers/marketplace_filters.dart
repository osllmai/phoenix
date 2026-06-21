import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'extension_entry.dart';

part 'marketplace_filters.g.dart';

/// Catalog filters (category + query) kept separate from the marketplace
/// controller, so the async catalog depends only on filters + repo — never the
/// controller. That lets install/uninstall invalidate the catalog without a cycle.
@riverpod
class MarketplaceFilters extends _$MarketplaceFilters {
  @override
  (ExtensionCategory?, String) build() => (null, '');

  void setCategory(ExtensionCategory? category) => state = (category, state.$2);

  void setQuery(String query) => state = (state.$1, query);
}
