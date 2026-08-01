import 'dart:io';

import 'device_capabilities.dart';

/// Detects host [DeviceCapabilities]: CPU cores + RAM from the system, and the
/// accelerator list from the engine when it implements [AcceleratorProbe]
/// (otherwise CPU-only). Pure Dart — no Flutter deps. Callers that already know
/// RAM (e.g. mobile via device_info_plus) may pass [ramBytesOverride].
class CapabilityDetector {
  const CapabilityDetector();

  Future<DeviceCapabilities> detect({
    Object? engine,
    int? ramBytesOverride,
  }) async {
    final accelerators = await _accelerators(engine);
    return DeviceCapabilities(
      platform: _platformName(),
      cpuCores: Platform.numberOfProcessors,
      ramBytes: ramBytesOverride ?? _readRamBytes() ?? 0,
      accelerators: accelerators.isEmpty ? const [Accelerator.cpu] : accelerators,
      detectedAt: DateTime.now(),
    );
  }

  Future<List<Accelerator>> _accelerators(Object? engine) async {
    if (engine is! AcceleratorProbe) return const [Accelerator.cpu];
    try {
      final list = await engine.availableAccelerators();
      return list.any((a) => a.backend == AcceleratorBackend.cpu)
          ? list
          : [Accelerator.cpu, ...list];
    } on Object {
      return const [Accelerator.cpu];
    }
  }

  String _platformName() {
    if (Platform.isLinux) return 'linux';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isWindows) return 'windows';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }

  int? _readRamBytes() {
    try {
      final file = File('/proc/meminfo');
      if (!file.existsSync()) return null;
      for (final line in file.readAsLinesSync()) {
        if (!line.startsWith('MemTotal:')) continue;
        final kb = int.tryParse(RegExp(r'\d+').firstMatch(line)?.group(0) ?? '');
        return kb == null ? null : kb * 1024;
      }
    } on Object {
      return null;
    }
    return null;
  }
}
