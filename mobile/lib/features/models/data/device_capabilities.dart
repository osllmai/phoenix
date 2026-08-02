import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_core/phoenix_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/ai/engine_provider.dart';

part 'device_capabilities.g.dart';

const double _desktopSentinelGb = 64;

/// Stores the detected capabilities on-device. Overridden in `main()` with the
/// SQLite-backed repository; defaults to in-memory for widgets/tests.
final deviceCapabilitiesRepositoryProvider =
    Provider<DeviceCapabilitiesRepository>(
        (ref) => InMemoryDeviceCapabilitiesRepository());

/// Detected host capabilities: CPU cores + RAM + accelerators the engine reports
/// (CPU-only when no GPU / no engine). Detected fresh each launch and persisted
/// to the local DB. Settings gate to this so the user can't pick a backend the
/// device lacks.
@riverpod
Future<DeviceCapabilities> deviceCapabilities(Ref ref) async {
  final ramGb = await ref.watch(deviceRamGbProvider.future);
  final engine = ref.watch(inferenceEngineProvider);
  final caps = await const CapabilityDetector().detect(
    engine: engine,
    ramBytesOverride: (ramGb * 1024 * 1024 * 1024).round(),
  );
  await ref.read(deviceCapabilitiesRepositoryProvider).save(caps);
  return caps;
}

@riverpod
Future<double> deviceRamGb(Ref ref) async {
  if (Platform.isAndroid) {
    final info = await DeviceInfoPlugin().androidInfo;
    return info.physicalRamSize / 1024;
  }
  return _readMemInfoGb() ?? _desktopSentinelGb;
}

double? _readMemInfoGb() {
  try {
    final file = File('/proc/meminfo');
    if (!file.existsSync()) return null;
    for (final line in file.readAsLinesSync()) {
      if (!line.startsWith('MemTotal:')) continue;
      final kb = int.tryParse(
        RegExp(r'\d+').firstMatch(line)?.group(0) ?? '',
      );
      if (kb == null) return null;
      return kb / (1024 * 1024);
    }
  } on Object {
    return null;
  }
  return null;
}
