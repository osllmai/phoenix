// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The active (engine-loaded) model, exposed to the UI.

@ProviderFor(ActiveModel)
final activeModelProvider = ActiveModelProvider._();

/// The active (engine-loaded) model, exposed to the UI.
final class ActiveModelProvider
    extends $NotifierProvider<ActiveModel, AiModel?> {
  /// The active (engine-loaded) model, exposed to the UI.
  ActiveModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeModelHash();

  @$internal
  @override
  ActiveModel create() => ActiveModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiModel?>(value),
    );
  }
}

String _$activeModelHash() => r'd884e149f54d97c7fc5d297f5f12ab4f81c7ef52';

/// The active (engine-loaded) model, exposed to the UI.

abstract class _$ActiveModel extends $Notifier<AiModel?> {
  AiModel? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AiModel?, AiModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AiModel?, AiModel?>,
              AiModel?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Id of the model currently loading (null when idle) — drives the per-tile
/// spinner and the concurrent-load guard.

@ProviderFor(LoadingModelId)
final loadingModelIdProvider = LoadingModelIdProvider._();

/// Id of the model currently loading (null when idle) — drives the per-tile
/// spinner and the concurrent-load guard.
final class LoadingModelIdProvider
    extends $NotifierProvider<LoadingModelId, int?> {
  /// Id of the model currently loading (null when idle) — drives the per-tile
  /// spinner and the concurrent-load guard.
  LoadingModelIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadingModelIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadingModelIdHash();

  @$internal
  @override
  LoadingModelId create() => LoadingModelId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$loadingModelIdHash() => r'315bc6bb2d65698c71e6b6efbdc70c61b444a0d0';

/// Id of the model currently loading (null when idle) — drives the per-tile
/// spinner and the concurrent-load guard.

abstract class _$LoadingModelId extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Loads + mutates the installed-model list.

@ProviderFor(ModelsController)
final modelsControllerProvider = ModelsControllerProvider._();

/// Loads + mutates the installed-model list.
final class ModelsControllerProvider
    extends $AsyncNotifierProvider<ModelsController, List<AiModel>> {
  /// Loads + mutates the installed-model list.
  ModelsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'modelsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$modelsControllerHash();

  @$internal
  @override
  ModelsController create() => ModelsController();
}

String _$modelsControllerHash() => r'6e0b3c6f8146d270fa0278b94769b6e8f43d5932';

/// Loads + mutates the installed-model list.

abstract class _$ModelsController extends $AsyncNotifier<List<AiModel>> {
  FutureOr<List<AiModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<AiModel>>, List<AiModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<AiModel>>, List<AiModel>>,
              AsyncValue<List<AiModel>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
