// A stand-in for `applocal_provider` that speaks the exact stdin/stdout
// protocol, so the SubprocessEngine wiring is testable without a GGUF binary.
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

  // Simulate model load.
  stdout.writeln('loading $model ...');
  await Future<void>.delayed(const Duration(milliseconds: 20));
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
      await _stream(promptLines.join('\n'), () => stopped);
      stopped = false;
      continue;
    }
    if (inPrompt) promptLines.add(line);
  }
}

// Echo the prompt back token-by-token (one word per chunk), then signal done.
Future<void> _stream(String prompt, bool Function() isStopped) async {
  final words = prompt.trim().split(RegExp(r'\s+'));
  for (final w in words) {
    if (isStopped()) break;
    stdout.writeln('$w ');
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
  stdout.writeln(done);
}
