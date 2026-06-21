import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_capabilities.g.dart';

const double _desktopSentinelGb = 64;

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
