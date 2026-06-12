import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'inference_port.dart';
import 'protocol.dart';

/// [InferencePort] backed by the existing `applocal_provider` (llama.cpp / GGUF)
/// binary, spawned as a child process and driven over stdin/stdout.
///
/// This is the Dart port of `core/provider/offlineprovider.cpp`: same binary,
/// same `__PROMPT__/__END__/__DONE_PROMPTPROCESS__` protocol — no Qt.
class SubprocessEngine implements InferencePort {
  /// [executablePath] is the engine binary (or a mock that speaks the protocol).
  /// [extraArgs] lets a mock be launched as `dart run mock.dart` etc.
  SubprocessEngine({required this.executablePath, this.extraArgs = const []});

  final String executablePath;
  final List<String> extraArgs;

  Process? _process;
  StreamSubscription<String>? _stdoutSub;
  EngineState _state = EngineState.idle;

  Completer<void>? _loaded;
  StreamController<String>? _tokens;

  @override
  EngineState get state => _state;

  @override
  Future<void> loadModel(String modelPath) async {
    if (_process != null) {
      throw StateError('Engine already started; dispose() before reloading.');
    }
    _state = EngineState.loadingModel;
    _loaded = Completer<void>();

    _process = await Process.start(
      executablePath,
      [...extraArgs, '--model', modelPath],
      // Merge stderr so engine diagnostics don't deadlock the pipe.
      mode: ProcessStartMode.normal,
    );

    _stdoutSub = _process!.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(_onLine, onError: _onError, onDone: _onProcessDone);
    // Drain stderr so it never blocks; surface as needed later.
    _process!.stderr.transform(utf8.decoder).listen((_) {});

    await _loaded!.future;
  }

  @override
  Stream<String> prompt(String prompt, {InferenceParams params = const InferenceParams()}) {
    final p = _process;
    if (p == null || _state == EngineState.idle || _state == EngineState.loadingModel) {
      throw StateError('No model loaded. Call loadModel() first.');
    }
    _tokens = StreamController<String>();
    _state = EngineState.generating;

    // params block → __PROMPT__ → text → __END__   (order per the C++ provider).
    p.stdin.write(params.toParamBlock());
    p.stdin.writeln(EngineProtocol.promptBegin);
    p.stdin.writeln('${prompt.trim()}\n${EngineProtocol.promptEnd}');

    return _tokens!.stream;
  }

  @override
  Future<void> stop() async {
    if (_state != EngineState.generating) return;
    _process?.stdin.writeln(EngineProtocol.stop);
    _state = EngineState.stopped;
  }

  @override
  Future<void> dispose() async {
    await _stdoutSub?.cancel();
    _process?.kill();
    await _tokens?.close();
    _process = null;
    _state = EngineState.idle;
  }

  // --- stdout protocol handling ------------------------------------------------

  void _onLine(String line) {
    // Model-load handshake.
    if (_state == EngineState.loadingModel) {
      if (line.trimRight().endsWith(EngineProtocol.loadingFinished)) {
        _state = EngineState.ready;
        if (!(_loaded?.isCompleted ?? true)) _loaded!.complete();
      }
      return;
    }

    // End-of-response marker may arrive with trailing token text on the line.
    final idx = line.indexOf(EngineProtocol.done);
    if (idx >= 0) {
      final before = line.substring(0, idx);
      if (before.isNotEmpty) _tokens?.add(before);
      _finishResponse();
      return;
    }

    if (_state == EngineState.generating) {
      _tokens?.add(line);
    }
  }

  void _finishResponse() {
    _state = EngineState.ready;
    _tokens?.close();
    _tokens = null;
  }

  void _onError(Object e, StackTrace st) {
    _state = EngineState.error;
    _tokens?.addError(e, st);
    if (!(_loaded?.isCompleted ?? true)) _loaded!.completeError(e, st);
  }

  void _onProcessDone() {
    if (_state == EngineState.generating) _finishResponse();
    if (!(_loaded?.isCompleted ?? true)) {
      _loaded!.completeError(StateError('Engine exited before model load.'));
    }
  }
}
