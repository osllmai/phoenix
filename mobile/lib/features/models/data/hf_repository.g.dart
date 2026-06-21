// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hf_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(hfRepository)
final hfRepositoryProvider = HfRepositoryProvider._();

final class HfRepositoryProvider
    extends $FunctionalProvider<HfRepository, HfRepository, HfRepository>
    with $Provider<HfRepository> {
  HfRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hfRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hfRepositoryHash();

  @$internal
  @override
  $ProviderElement<HfRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HfRepository create(Ref ref) {
    return hfRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HfRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HfRepository>(value),
    );
  }
}

String _$hfRepositoryHash() => r'4857d3579d6c88eef3f8727b8f678573b93f71a1';

@ProviderFor(hfSearch)
final hfSearchProvider = HfSearchFamily._();

final class HfSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CatalogEntry>>,
          List<CatalogEntry>,
          FutureOr<List<CatalogEntry>>
        >
    with
        $FutureModifier<List<CatalogEntry>>,
        $FutureProvider<List<CatalogEntry>> {
  HfSearchProvider._({
    required HfSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hfSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hfSearchHash();

  @override
  String toString() {
    return r'hfSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CatalogEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CatalogEntry>> create(Ref ref) {
    final argument = this.argument as String;
    return hfSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HfSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hfSearchHash() => r'8c85b1fd4d92420c15dcfbd39903196a1d76644f';

final class HfSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CatalogEntry>>, String> {
  HfSearchFamily._()
    : super(
        retry: null,
        name: r'hfSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HfSearchProvider call(String query) =>
      HfSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'hfSearchProvider';
}

@ProviderFor(hfModelFiles)
final hfModelFilesProvider = HfModelFilesFamily._();

final class HfModelFilesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CatalogEntry>>,
          List<CatalogEntry>,
          FutureOr<List<CatalogEntry>>
        >
    with
        $FutureModifier<List<CatalogEntry>>,
        $FutureProvider<List<CatalogEntry>> {
  HfModelFilesProvider._({
    required HfModelFilesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hfModelFilesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hfModelFilesHash();

  @override
  String toString() {
    return r'hfModelFilesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CatalogEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CatalogEntry>> create(Ref ref) {
    final argument = this.argument as String;
    return hfModelFiles(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HfModelFilesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hfModelFilesHash() => r'e16bde0db5cba7bb11cdff0d0b2fb93c804807fe';

final class HfModelFilesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CatalogEntry>>, String> {
  HfModelFilesFamily._()
    : super(
        retry: null,
        name: r'hfModelFilesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HfModelFilesProvider call(String repoId) =>
      HfModelFilesProvider._(argument: repoId, from: this);

  @override
  String toString() => r'hfModelFilesProvider';
}
