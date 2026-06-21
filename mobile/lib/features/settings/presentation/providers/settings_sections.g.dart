// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_sections.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsSections)
final settingsSectionsProvider = SettingsSectionsProvider._();

final class SettingsSectionsProvider
    extends
        $FunctionalProvider<
          List<SettingsSection>,
          List<SettingsSection>,
          List<SettingsSection>
        >
    with $Provider<List<SettingsSection>> {
  SettingsSectionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsSectionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsSectionsHash();

  @$internal
  @override
  $ProviderElement<List<SettingsSection>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<SettingsSection> create(Ref ref) {
    return settingsSections(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SettingsSection> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SettingsSection>>(value),
    );
  }
}

String _$settingsSectionsHash() => r'94a2a8e06e94a67affae0b2d39af986acb9ee155';
