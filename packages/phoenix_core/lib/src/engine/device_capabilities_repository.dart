import 'device_capabilities.dart';

/// Stores the detected [DeviceCapabilities] for the host (a single row). The app
/// detects on launch and caches here so gating/clamping don't re-probe each time.
abstract interface class DeviceCapabilitiesRepository {
  Future<DeviceCapabilities?> load();
  Future<void> save(DeviceCapabilities caps);
}

/// In-memory backing for tests / hosts without a database.
class InMemoryDeviceCapabilitiesRepository
    implements DeviceCapabilitiesRepository {
  InMemoryDeviceCapabilitiesRepository([this._caps]);

  DeviceCapabilities? _caps;

  @override
  Future<DeviceCapabilities?> load() async => _caps;

  @override
  Future<void> save(DeviceCapabilities caps) async => _caps = caps;
}
