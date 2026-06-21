// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(catalogRepository)
final catalogRepositoryProvider = CatalogRepositoryProvider._();

final class CatalogRepositoryProvider
    extends
        $FunctionalProvider<
          CatalogRepository,
          CatalogRepository,
          CatalogRepository
        >
    with $Provider<CatalogRepository> {
  CatalogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogRepositoryHash();

  @$internal
  @override
  $ProviderElement<CatalogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CatalogRepository create(Ref ref) {
    return catalogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogRepository>(value),
    );
  }
}

String _$catalogRepositoryHash() => r'55d48f4e5e904e6becab4f8f3315454dee303495';

@ProviderFor(modelCatalog)
final modelCatalogProvider = ModelCatalogProvider._();

final class ModelCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, List<CatalogEntry>>>,
          Map<String, List<CatalogEntry>>,
          FutureOr<Map<String, List<CatalogEntry>>>
        >
    with
        $FutureModifier<Map<String, List<CatalogEntry>>>,
        $FutureProvider<Map<String, List<CatalogEntry>>> {
  ModelCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'modelCatalogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$modelCatalogHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, List<CatalogEntry>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, List<CatalogEntry>>> create(Ref ref) {
    return modelCatalog(ref);
  }
}

String _$modelCatalogHash() => r'57f6446b4b4e0304e3370e520097bbd3969ddf66';
