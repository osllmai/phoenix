// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_filters.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Catalog filters (category + query) kept separate from the marketplace
/// controller, so the async catalog depends only on filters + repo — never the
/// controller. That lets install/uninstall invalidate the catalog without a cycle.

@ProviderFor(MarketplaceFilters)
final marketplaceFiltersProvider = MarketplaceFiltersProvider._();

/// Catalog filters (category + query) kept separate from the marketplace
/// controller, so the async catalog depends only on filters + repo — never the
/// controller. That lets install/uninstall invalidate the catalog without a cycle.
final class MarketplaceFiltersProvider
    extends
        $NotifierProvider<MarketplaceFilters, (ExtensionCategory?, String)> {
  /// Catalog filters (category + query) kept separate from the marketplace
  /// controller, so the async catalog depends only on filters + repo — never the
  /// controller. That lets install/uninstall invalidate the catalog without a cycle.
  MarketplaceFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketplaceFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketplaceFiltersHash();

  @$internal
  @override
  MarketplaceFilters create() => MarketplaceFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((ExtensionCategory?, String) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(ExtensionCategory?, String)>(value),
    );
  }
}

String _$marketplaceFiltersHash() =>
    r'b3b75e5807a306ab52fd0180d43a504658909dd4';

/// Catalog filters (category + query) kept separate from the marketplace
/// controller, so the async catalog depends only on filters + repo — never the
/// controller. That lets install/uninstall invalidate the catalog without a cycle.

abstract class _$MarketplaceFilters
    extends $Notifier<(ExtensionCategory?, String)> {
  (ExtensionCategory?, String) build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<(ExtensionCategory?, String), (ExtensionCategory?, String)>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                (ExtensionCategory?, String),
                (ExtensionCategory?, String)
              >,
              (ExtensionCategory?, String),
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
