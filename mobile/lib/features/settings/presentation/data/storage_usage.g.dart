// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_usage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Computes actual usage: installed model files + app data (DB/settings) + cache.

@ProviderFor(storageUsage)
final storageUsageProvider = StorageUsageProvider._();

/// Computes actual usage: installed model files + app data (DB/settings) + cache.

final class StorageUsageProvider
    extends
        $FunctionalProvider<
          AsyncValue<StorageUsage>,
          StorageUsage,
          FutureOr<StorageUsage>
        >
    with $FutureModifier<StorageUsage>, $FutureProvider<StorageUsage> {
  /// Computes actual usage: installed model files + app data (DB/settings) + cache.
  StorageUsageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageUsageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageUsageHash();

  @$internal
  @override
  $FutureProviderElement<StorageUsage> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StorageUsage> create(Ref ref) {
    return storageUsage(ref);
  }
}

String _$storageUsageHash() => r'210c7da47ee3c370c52c06ff881528635c39f025';

/// Deletes the app cache directory's contents; returns bytes actually freed.
/// The caller invalidates [storageUsageProvider] from a live ref to refresh.

@ProviderFor(CacheCleaner)
final cacheCleanerProvider = CacheCleanerProvider._();

/// Deletes the app cache directory's contents; returns bytes actually freed.
/// The caller invalidates [storageUsageProvider] from a live ref to refresh.
final class CacheCleanerProvider extends $NotifierProvider<CacheCleaner, void> {
  /// Deletes the app cache directory's contents; returns bytes actually freed.
  /// The caller invalidates [storageUsageProvider] from a live ref to refresh.
  CacheCleanerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cacheCleanerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cacheCleanerHash();

  @$internal
  @override
  CacheCleaner create() => CacheCleaner();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$cacheCleanerHash() => r'68ad40ceb7ec4e8b31789f9d915b0b4a334489cb';

/// Deletes the app cache directory's contents; returns bytes actually freed.
/// The caller invalidates [storageUsageProvider] from a live ref to refresh.

abstract class _$CacheCleaner extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
