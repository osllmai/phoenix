// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'welcome_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the onboarding wizard: step navigation, model selection, the
/// telemetry opt-in and a stubbed background model download.

@ProviderFor(WelcomeController)
final welcomeControllerProvider = WelcomeControllerProvider._();

/// Drives the onboarding wizard: step navigation, model selection, the
/// telemetry opt-in and a stubbed background model download.
final class WelcomeControllerProvider
    extends $NotifierProvider<WelcomeController, WelcomeState> {
  /// Drives the onboarding wizard: step navigation, model selection, the
  /// telemetry opt-in and a stubbed background model download.
  WelcomeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'welcomeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$welcomeControllerHash();

  @$internal
  @override
  WelcomeController create() => WelcomeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WelcomeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WelcomeState>(value),
    );
  }
}

String _$welcomeControllerHash() => r'5e9f8a3e862edf7cffa4c78ba6b8b5dd51f7ca92';

/// Drives the onboarding wizard: step navigation, model selection, the
/// telemetry opt-in and a stubbed background model download.

abstract class _$WelcomeController extends $Notifier<WelcomeState> {
  WelcomeState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<WelcomeState, WelcomeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WelcomeState, WelcomeState>,
              WelcomeState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
