// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_capabilities.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Detected host capabilities: CPU cores + RAM + accelerators the engine reports
/// (CPU-only when no GPU / no engine). Detected fresh each launch and persisted
/// to the local DB. Settings gate to this so the user can't pick a backend the
/// device lacks.

@ProviderFor(deviceCapabilities)
final deviceCapabilitiesProvider = DeviceCapabilitiesProvider._();

/// Detected host capabilities: CPU cores + RAM + accelerators the engine reports
/// (CPU-only when no GPU / no engine). Detected fresh each launch and persisted
/// to the local DB. Settings gate to this so the user can't pick a backend the
/// device lacks.

final class DeviceCapabilitiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<DeviceCapabilities>,
          DeviceCapabilities,
          FutureOr<DeviceCapabilities>
        >
    with
        $FutureModifier<DeviceCapabilities>,
        $FutureProvider<DeviceCapabilities> {
  /// Detected host capabilities: CPU cores + RAM + accelerators the engine reports
  /// (CPU-only when no GPU / no engine). Detected fresh each launch and persisted
  /// to the local DB. Settings gate to this so the user can't pick a backend the
  /// device lacks.
  DeviceCapabilitiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceCapabilitiesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceCapabilitiesHash();

  @$internal
  @override
  $FutureProviderElement<DeviceCapabilities> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DeviceCapabilities> create(Ref ref) {
    return deviceCapabilities(ref);
  }
}

String _$deviceCapabilitiesHash() =>
    r'0eb5be771407d345119cfd66a17085b7c80e8f24';

@ProviderFor(deviceRamGb)
final deviceRamGbProvider = DeviceRamGbProvider._();

final class DeviceRamGbProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  DeviceRamGbProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceRamGbProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceRamGbHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return deviceRamGb(ref);
  }
}

String _$deviceRamGbHash() => r'd4eec714c37e96c1f9d86e9e5b6a86b6cd354064';
