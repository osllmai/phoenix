// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extensions_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(extensionsRepository)
final extensionsRepositoryProvider = ExtensionsRepositoryProvider._();

final class ExtensionsRepositoryProvider
    extends
        $FunctionalProvider<
          ExtensionsRepository,
          ExtensionsRepository,
          ExtensionsRepository
        >
    with $Provider<ExtensionsRepository> {
  ExtensionsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'extensionsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$extensionsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExtensionsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExtensionsRepository create(Ref ref) {
    return extensionsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExtensionsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExtensionsRepository>(value),
    );
  }
}

String _$extensionsRepositoryHash() =>
    r'266525b8e6fbf87f0e67aa4cae4532c1af4dfc1d';
