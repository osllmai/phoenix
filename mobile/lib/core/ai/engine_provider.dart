import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_core/phoenix_core.dart';

/// Resolves the path to the `applocal_provider` engine binary for the host OS.
///
/// Ships alongside the app under `resources/providers/local_provider/`. Override
/// in tests/dev by providing [engineExecutableProvider].
String defaultEngineExecutable() {
  final (platformDir, exe) = Platform.isWindows
      ? ('windows_llama', 'applocal_provider.exe')
      : ('linux_llama', 'applocal_provider');
  final dir =
      Platform.environment['PHOENIX_ENGINE_DIR'] ?? 'engine/local_provider/$platformDir';
  return '$dir/$exe';
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
