// A stand-in for `applocal_provider` that speaks the exact stdin/stdout
// protocol, so the SubprocessEngine wiring is testable without a GGUF binary.
//
// Scriptable via the --model path:
//   contains 'LOADFAIL' -> write to stderr and exit 1 before loading finishes
//   contains 'CRASH'    -> emit one token then exit(70) mid-generation
//
// Run indirectly via SubprocessEngine(executablePath: 'dart',
//   extraArgs: ['run', '<this file>']).
import 'dart:async';
import 'dart:convert';
import 'dart:io';

const loadingFinished = '__LoadingModel__Finished__';
const promptBegin = '__PROMPT__';
const promptEnd = '__END__';
const done = '__DONE_PROMPTPROCESS__';
const stop = '__STOP__';
const paramsBegin = '__PARAMS_SETTINGS__';
const paramsEnd = '__END_PARAMS_SETTINGS__';

Future<void> main(List<String> args) async {
  final modelIdx = args.indexOf('--model');
  final model = (modelIdx >= 0 && modelIdx + 1 < args.length) ? args[modelIdx + 1] : '<none>';

  if (model.contains('LOADFAIL')) {
    stderr.writeln('mock: failed to load $model');
    exit(1);
  }

  // Simulate model load.
  stdout.writeln('loading $model ...');
  // 'HANG' never finishes loading — lets a test dispose() mid-load.
  final loadMs = model.contains('HANG') ? 10000 : 20;
  await Future<void>.delayed(Duration(milliseconds: loadMs));
  stdout.writeln(loadingFinished);

  final promptLines = <String>[];
  var inPrompt = false;
  var stopped = false;

  await for (final line in stdin
      .transform(utf8.decoder)
      .transform(const LineSplitter())) {
    if (line == stop) {
      stopped = true;
      continue;
    }
    if (line.startsWith(paramsBegin) || line.startsWith(paramsEnd) || line.contains('=')) {
      continue; // ignore the params block in the mock
    }
    if (line == promptBegin) {
      inPrompt = true;
      promptLines.clear();
      continue;
    }
    if (inPrompt && line == promptEnd) {
      inPrompt = false;
      stopped = false;
      // Fire-and-forget so the stdin loop keeps reading __STOP__ mid-stream
      // (the real engine generates on a separate thread — mirror that).
      unawaited(_stream(promptLines.join('\n'), () => stopped, model));
      continue;
    }
    if (inPrompt) promptLines.add(line);
  }
}

// Echo the prompt back token-by-token (one word per chunk), then signal done.
Future<void> _stream(String prompt, bool Function() isStopped, String model) async {
  final words = prompt.trim().split(RegExp(r'\s+'));
  for (final w in words) {
    if (isStopped()) break;
    stdout.writeln('$w ');
    if (model.contains('CRASH')) exit(70); // die mid-generation
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
  stdout.writeln(done);
}
