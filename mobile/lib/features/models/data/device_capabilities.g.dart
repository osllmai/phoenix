// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_capabilities.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
