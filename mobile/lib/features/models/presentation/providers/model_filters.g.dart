// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_filters.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Catalog search query.

@ProviderFor(ModelQuery)
final modelQueryProvider = ModelQueryProvider._();

/// Catalog search query.
final class ModelQueryProvider extends $NotifierProvider<ModelQuery, String> {
  /// Catalog search query.
  ModelQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'modelQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$modelQueryHash();

  @$internal
  @override
  ModelQuery create() => ModelQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$modelQueryHash() => r'c0e68b69a95b27193bb096ab77ebfa110665054e';

/// Catalog search query.

abstract class _$ModelQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Favorites-only filter toggle.

@ProviderFor(ModelFavOnly)
final modelFavOnlyProvider = ModelFavOnlyProvider._();

/// Favorites-only filter toggle.
final class ModelFavOnlyProvider extends $NotifierProvider<ModelFavOnly, bool> {
  /// Favorites-only filter toggle.
  ModelFavOnlyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'modelFavOnlyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$modelFavOnlyHash();

  @$internal
  @override
  ModelFavOnly create() => ModelFavOnly();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$modelFavOnlyHash() => r'592b67faa5f567434b5be21ac0370142658d93ff';

/// Favorites-only filter toggle.

abstract class _$ModelFavOnly extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Catalog sort order.

@ProviderFor(ModelSortPref)
final modelSortPrefProvider = ModelSortPrefProvider._();

/// Catalog sort order.
final class ModelSortPrefProvider
    extends $NotifierProvider<ModelSortPref, ModelSort> {
  /// Catalog sort order.
  ModelSortPrefProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'modelSortPrefProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$modelSortPrefHash();

  @$internal
  @override
  ModelSortPref create() => ModelSortPref();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ModelSort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ModelSort>(value),
    );
  }
}

String _$modelSortPrefHash() => r'76d129fde1efd94595338375e7408728bd6666d7';

/// Catalog sort order.

abstract class _$ModelSortPref extends $Notifier<ModelSort> {
  ModelSort build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ModelSort, ModelSort>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ModelSort, ModelSort>,
              ModelSort,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
