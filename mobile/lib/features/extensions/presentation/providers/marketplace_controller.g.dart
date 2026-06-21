// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MarketplaceController)
final marketplaceControllerProvider = MarketplaceControllerProvider._();

final class MarketplaceControllerProvider
    extends $NotifierProvider<MarketplaceController, MarketplaceState> {
  MarketplaceControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketplaceControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketplaceControllerHash();

  @$internal
  @override
  MarketplaceController create() => MarketplaceController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarketplaceState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarketplaceState>(value),
    );
  }
}

String _$marketplaceControllerHash() =>
    r'72b6628b1cbdf29f930544b21585620ae21030c1';

abstract class _$MarketplaceController extends $Notifier<MarketplaceState> {
  MarketplaceState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MarketplaceState, MarketplaceState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MarketplaceState, MarketplaceState>,
              MarketplaceState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(marketplaceCatalog)
final marketplaceCatalogProvider = MarketplaceCatalogProvider._();

final class MarketplaceCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ExtensionEntry>>,
          List<ExtensionEntry>,
          FutureOr<List<ExtensionEntry>>
        >
    with
        $FutureModifier<List<ExtensionEntry>>,
        $FutureProvider<List<ExtensionEntry>> {
  MarketplaceCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketplaceCatalogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketplaceCatalogHash();

  @$internal
  @override
  $FutureProviderElement<List<ExtensionEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ExtensionEntry>> create(Ref ref) {
    return marketplaceCatalog(ref);
  }
}

String _$marketplaceCatalogHash() =>
    r'88967b0058eddddf2b9e2e59f709b0bf88da676a';

@ProviderFor(selectedExtension)
final selectedExtensionProvider = SelectedExtensionProvider._();

final class SelectedExtensionProvider
    extends
        $FunctionalProvider<ExtensionEntry?, ExtensionEntry?, ExtensionEntry?>
    with $Provider<ExtensionEntry?> {
  SelectedExtensionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedExtensionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedExtensionHash();

  @$internal
  @override
  $ProviderElement<ExtensionEntry?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ExtensionEntry? create(Ref ref) {
    return selectedExtension(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExtensionEntry? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExtensionEntry?>(value),
    );
  }
}

String _$selectedExtensionHash() => r'15a17e9162167dd94e2fc1a6e605fd9d7502d192';
