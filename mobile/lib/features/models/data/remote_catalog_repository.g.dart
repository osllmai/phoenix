// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_catalog_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(remoteCatalog)
final remoteCatalogProvider = RemoteCatalogProvider._();

final class RemoteCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CatalogEntry>>,
          List<CatalogEntry>,
          FutureOr<List<CatalogEntry>>
        >
    with
        $FutureModifier<List<CatalogEntry>>,
        $FutureProvider<List<CatalogEntry>> {
  RemoteCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteCatalogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteCatalogHash();

  @$internal
  @override
  $FutureProviderElement<List<CatalogEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CatalogEntry>> create(Ref ref) {
    return remoteCatalog(ref);
  }
}

String _$remoteCatalogHash() => r'31f5f43d8565672acd60666d858093b61d921343';
