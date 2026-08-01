import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:phoenix_core/phoenix_core.dart';

/// Resolves the path to the `applocal_provider` engine binary for the host OS.
///
/// `PHOENIX_ENGINE_DIR` wins when set (with or without the platform subdir).
/// Otherwise the binary is searched next to the running executable and up the
/// tree from the working directory, so a `flutter run` from `mobile/` finds the
/// repo-root `engine/` copy.
String defaultEngineExecutable() {
  final (platformDir, exe) = Platform.isWindows
      ? ('windows_llama', 'applocal_provider.exe')
      : ('linux_llama', 'applocal_provider');

  final roots = <String>[
    ?Platform.environment['PHOENIX_ENGINE_DIR'],
    p.dirname(Platform.resolvedExecutable),
    Directory.current.path,
    p.dirname(Directory.current.path),
  ];

  for (final root in roots) {
    for (final rel in ['', platformDir, 'engine/local_provider/$platformDir']) {
      final candidate = p.join(root, rel, exe);
      if (File(candidate).existsSync()) return p.normalize(candidate);
    }
  }
  return p.join('engine/local_provider/$platformDir', exe);
}

/// Path to the engine binary (overridable in tests).
final engineExecutableProvider = Provider<String>((ref) => defaultEngineExecutable());

/// The single app-wide [InferencePort]. Swap [SubprocessEngine] for a future
/// `FfiEngine` here (mobile) without touching any caller.
final inferenceEngineProvider = Provider<InferencePort>((ref) {
  final engine = SubprocessEngine(executablePath: ref.watch(engineExecutableProvider));
  ref.onDispose(engine.dispose);
  return engine;
});
