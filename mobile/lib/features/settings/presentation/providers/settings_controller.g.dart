// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads persisted preferences on build and writes each change back through the
/// [SettingsRepository]. `activeSection` is transient UI state (not persisted).

@ProviderFor(SettingsController)
final settingsControllerProvider = SettingsControllerProvider._();

/// Loads persisted preferences on build and writes each change back through the
/// [SettingsRepository]. `activeSection` is transient UI state (not persisted).
final class SettingsControllerProvider
    extends $AsyncNotifierProvider<SettingsController, SettingsState> {
  /// Loads persisted preferences on build and writes each change back through the
  /// [SettingsRepository]. `activeSection` is transient UI state (not persisted).
  SettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsControllerHash();

  @$internal
  @override
  SettingsController create() => SettingsController();
}

String _$settingsControllerHash() =>
    r'da9acd56a60cfe1e0302326ac47d584d3633bb7a';

/// Loads persisted preferences on build and writes each change back through the
/// [SettingsRepository]. `activeSection` is transient UI state (not persisted).

abstract class _$SettingsController extends $AsyncNotifier<SettingsState> {
  FutureOr<SettingsState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SettingsState>, SettingsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SettingsState>, SettingsState>,
              AsyncValue<SettingsState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
