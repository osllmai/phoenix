import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_info.g.dart';

/// Real app + runtime info for the About section — sourced from the platform,
/// never hardcoded.
class AppInfo {
  const AppInfo({
    required this.version,
    required this.build,
    required this.platform,
    required this.runtime,
    required this.logPath,
  });

  final String version;
  final String build;
  final String platform;
  final String runtime;
  final String logPath;
}

@riverpod
Future<AppInfo> appInfo(Ref ref) async {
  final pkg = await PackageInfo.fromPlatform();
  final support = await getApplicationSupportDirectory();
  return AppInfo(
    version: pkg.version,
    build: pkg.buildNumber,
    platform: await _platformLabel(),
    runtime: 'Dart ${Platform.version.split(' ').first}',
    logPath: p.join(support.path, 'logs'),
  );
}

Future<String> _platformLabel() async {
  final info = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      final a = await info.androidInfo;
      return 'Android ${a.version.release} · ${a.model}';
    }
    if (Platform.isIOS) {
      final i = await info.iosInfo;
      return 'iOS ${i.systemVersion} · ${i.model}';
    }
    if (Platform.isMacOS) {
      final m = await info.macOsInfo;
      return 'macOS ${m.osRelease}';
    }
    if (Platform.isWindows) {
      final w = await info.windowsInfo;
      return 'Windows ${w.displayVersion}';
    }
    if (Platform.isLinux) {
      return (await info.linuxInfo).prettyName;
    }
  } on Object {
    return Platform.operatingSystem;
  }
  return Platform.operatingSystem;
}
