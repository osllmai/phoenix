import 'dart:io';

import 'package:phoenix_core/phoenix_core.dart';

/// Drives the production [SubprocessEngine] against a real engine binary and a
/// real GGUF — the same code path `ModelManager.select` + `ChatService.prompt`
/// use. Usage: `dart run tool/real_engine_smoke.dart <engineExe> <model.gguf>`
Future<void> main(List<String> args) async {
  final exe = args.isNotEmpty ? args[0] : 'engine/local_provider/linux_llama/applocal_provider';
  final model = args.length > 1
      ? args[1]
      : '/run/media/llmserver/DATA/models/Meta-Llama-3-8B-Instruct.Q4_0.gguf';

  final engine = SubprocessEngine(executablePath: exe, loadTimeout: const Duration(seconds: 300));
  stdout.writeln('[smoke] loadModel via $exe');
  await engine.loadModel(model);
  stdout.writeln('[smoke] engine.state=${engine.state}');

  final buf = StringBuffer();
  await for (final token in engine.prompt(
    'What is the capital of France? Answer in one short sentence.',
    params: const InferenceParams(maxTokens: 48),
  )) {
    stdout.write(token);
    buf.write(token);
  }
  stdout.writeln('\n[smoke] response chars=${buf.length}, state=${engine.state}');
  await engine.dispose();
  stdout.writeln('[smoke] disposed OK');
}
