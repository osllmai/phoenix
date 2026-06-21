// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'welcome_models.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The three starter models offered on the choose-model step, sourced from the
/// real bundled catalog (recommended picks, smallest first).

@ProviderFor(onboardingModels)
final onboardingModelsProvider = OnboardingModelsProvider._();

/// The three starter models offered on the choose-model step, sourced from the
/// real bundled catalog (recommended picks, smallest first).

final class OnboardingModelsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OnboardingModel>>,
          List<OnboardingModel>,
          FutureOr<List<OnboardingModel>>
        >
    with
        $FutureModifier<List<OnboardingModel>>,
        $FutureProvider<List<OnboardingModel>> {
  /// The three starter models offered on the choose-model step, sourced from the
  /// real bundled catalog (recommended picks, smallest first).
  OnboardingModelsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingModelsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingModelsHash();

  @$internal
  @override
  $FutureProviderElement<List<OnboardingModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<OnboardingModel>> create(Ref ref) {
    return onboardingModels(ref);
  }
}

String _$onboardingModelsHash() => r'9d76a3e303434591b86c37b9fc9f514b826bbf63';
