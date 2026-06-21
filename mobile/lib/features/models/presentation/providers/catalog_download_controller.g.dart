// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_download_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(modelDownloader)
final modelDownloaderProvider = ModelDownloaderProvider._();

final class ModelDownloaderProvider
    extends
        $FunctionalProvider<ModelDownloader, ModelDownloader, ModelDownloader>
    with $Provider<ModelDownloader> {
  ModelDownloaderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'modelDownloaderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$modelDownloaderHash();

  @$internal
  @override
  $ProviderElement<ModelDownloader> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ModelDownloader create(Ref ref) {
    return modelDownloader(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ModelDownloader value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ModelDownloader>(value),
    );
  }
}

String _$modelDownloaderHash() => r'9a6ad9ec5f6bc54c91481d8843283dc735163cd1';

@ProviderFor(CatalogDownloadController)
final catalogDownloadControllerProvider = CatalogDownloadControllerProvider._();

final class CatalogDownloadControllerProvider
    extends
        $NotifierProvider<
          CatalogDownloadController,
          Map<String, DownloadProgress>
        > {
  CatalogDownloadControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogDownloadControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogDownloadControllerHash();

  @$internal
  @override
  CatalogDownloadController create() => CatalogDownloadController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, DownloadProgress> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, DownloadProgress>>(
        value,
      ),
    );
  }
}

String _$catalogDownloadControllerHash() =>
    r'49d7fd20375badbcf367bb299f28bc1c4fbb0bea';

abstract class _$CatalogDownloadController
    extends $Notifier<Map<String, DownloadProgress>> {
  Map<String, DownloadProgress> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              Map<String, DownloadProgress>,
              Map<String, DownloadProgress>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, DownloadProgress>,
                Map<String, DownloadProgress>
              >,
              Map<String, DownloadProgress>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(entryInstalled)
final entryInstalledProvider = EntryInstalledFamily._();

final class EntryInstalledProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  EntryInstalledProvider._({
    required EntryInstalledFamily super.from,
    required CatalogEntry super.argument,
  }) : super(
         retry: null,
         name: r'entryInstalledProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$entryInstalledHash();

  @override
  String toString() {
    return r'entryInstalledProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as CatalogEntry;
    return entryInstalled(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EntryInstalledProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$entryInstalledHash() => r'b99273893645563dfe49bbe9f6f7bdb1f98eaf5f';

final class EntryInstalledFamily extends $Family
    with $FunctionalFamilyOverride<bool, CatalogEntry> {
  EntryInstalledFamily._()
    : super(
        retry: null,
        name: r'entryInstalledProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EntryInstalledProvider call(CatalogEntry entry) =>
      EntryInstalledProvider._(argument: entry, from: this);

  @override
  String toString() => r'entryInstalledProvider';
}
