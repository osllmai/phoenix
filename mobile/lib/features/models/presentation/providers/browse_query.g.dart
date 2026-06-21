// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browse_query.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BrowseSearch)
final browseSearchProvider = BrowseSearchProvider._();

final class BrowseSearchProvider
    extends $NotifierProvider<BrowseSearch, String> {
  BrowseSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'browseSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$browseSearchHash();

  @$internal
  @override
  BrowseSearch create() => BrowseSearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$browseSearchHash() => r'2b52b1945b9b78d6a842c72670f5fdf18a69930c';

abstract class _$BrowseSearch extends $Notifier<String> {
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

@ProviderFor(BrowseSort)
final browseSortProvider = BrowseSortProvider._();

final class BrowseSortProvider
    extends $NotifierProvider<BrowseSort, BrowseSortMode> {
  BrowseSortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'browseSortProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$browseSortHash();

  @$internal
  @override
  BrowseSort create() => BrowseSort();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrowseSortMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrowseSortMode>(value),
    );
  }
}

String _$browseSortHash() => r'a28aab126bc393b1cd0eb2679dda63b715e27ce9';

abstract class _$BrowseSort extends $Notifier<BrowseSortMode> {
  BrowseSortMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BrowseSortMode, BrowseSortMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BrowseSortMode, BrowseSortMode>,
              BrowseSortMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(BrowseAscending)
final browseAscendingProvider = BrowseAscendingProvider._();

final class BrowseAscendingProvider
    extends $NotifierProvider<BrowseAscending, bool> {
  BrowseAscendingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'browseAscendingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$browseAscendingHash();

  @$internal
  @override
  BrowseAscending create() => BrowseAscending();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$browseAscendingHash() => r'c586ade7949730f1a91cf07b8ced15e29531c5c7';

abstract class _$BrowseAscending extends $Notifier<bool> {
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

@ProviderFor(BrowseSourceSel)
final browseSourceSelProvider = BrowseSourceSelProvider._();

final class BrowseSourceSelProvider
    extends $NotifierProvider<BrowseSourceSel, BrowseSource> {
  BrowseSourceSelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'browseSourceSelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$browseSourceSelHash();

  @$internal
  @override
  BrowseSourceSel create() => BrowseSourceSel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrowseSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrowseSource>(value),
    );
  }
}

String _$browseSourceSelHash() => r'e26aa0930f3ba290b433cc0d4136978350866eda';

abstract class _$BrowseSourceSel extends $Notifier<BrowseSource> {
  BrowseSource build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BrowseSource, BrowseSource>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BrowseSource, BrowseSource>,
              BrowseSource,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(BrowseCategorySel)
final browseCategorySelProvider = BrowseCategorySelProvider._();

final class BrowseCategorySelProvider
    extends $NotifierProvider<BrowseCategorySel, BrowseCategory> {
  BrowseCategorySelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'browseCategorySelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$browseCategorySelHash();

  @$internal
  @override
  BrowseCategorySel create() => BrowseCategorySel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrowseCategory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrowseCategory>(value),
    );
  }
}

String _$browseCategorySelHash() => r'0b6ccdcea8e87c13728d3a94fe4529a6d8eccd66';

abstract class _$BrowseCategorySel extends $Notifier<BrowseCategory> {
  BrowseCategory build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BrowseCategory, BrowseCategory>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BrowseCategory, BrowseCategory>,
              BrowseCategory,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
