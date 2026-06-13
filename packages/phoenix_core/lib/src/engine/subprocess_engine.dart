import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'engine_exceptions.dart';
import 'inference_port.dart';
import 'protocol.dart';
import 'stderr_buffer.dart';
import 'stdout_router.dart';
import 'wire_guard.dart';

/// [InferencePort] backed by the existing `applocal_provider` (llama.cpp / GGUF)
/// binary, spawned as a child process and driven over stdin/stdout.
///
/// Dart port of `core/provider/offlineprovider.cpp`: same binary, same
/// `__PROMPT__/__END__/__DONE_PROMPTPROCESS__` protocol — no Qt.
class SubprocessEngine implements InferencePort {
  /// [executablePath] is the engine binary (or a mock that speaks the protocol).
  /// [extraArgs] lets a mock be launched as `dart run mock.dart` etc.
  SubprocessEngine({
    required this.executablePath,
    this.extraArgs = const [],
    this.loadTimeout = const Duration(seconds: 120),
    this.stopTimeout = const Duration(seconds: 5),
  });

  final String executablePath;
  final List<String> extraArgs;
  final Duration loadTimeout;
  final Duration stopTimeout;

  Process? _process;
  StreamSubscription<String>? _stdoutSub;
  EngineState _state = EngineState.idle;
  Completer<void>? _loaded;
  StreamController<String>? _tokens;
  StdoutRouter? _router;
  Timer? _stopTimer;
  final _stderr = StderrBuffer();

  @override
  EngineState get state => _state;

  @override
  Future<void> loadModel(String modelPath) async {
    if (_state == EngineState.loadingModel) {
      throw StateError('A model load is already in progress.');
    }
    if (_process != null) {
      if (_state == EngineState.generating) {
        throw StateError('Cannot load a model while generating; stop() first.');
      }
      await dispose(); // S4: model switch — reap the old process first.
    }
    _state = EngineState.loadingModel;
    _loaded = Completer<void>();
    _stderr.clear();
    _router = StdoutRouter(
      onReady: _onReady,
      onToken: (t) => _tokens?.add(t),
      onDone: _finishResponse,
    );

    final p = await Process.start(executablePath, [...extraArgs, '--model', modelPath]);
    _process = p;
    unawaited(p.exitCode.then(_onExit));
    _stdoutSub = p.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((l) => _router?.handle(l, _state), onError: _onError);
    p.stderr.transform(utf8.decoder).transform(const LineSplitter()).listen(_stderr.add);

    await _loaded!.future.timeout(loadTimeout, onTimeout: () {
      unawaited(dispose());
      throw _fail(EngineFailure.error, 'Model load timed out');
    });
  }

  @override
  Stream<String> prompt(String prompt, {InferenceParams params = const InferenceParams()}) {
    if (_state != EngineState.ready) {
      throw StateError(_state == EngineState.generating
          ? 'A generation is already in flight; stop() first.'
          : 'No model loaded. Call loadModel() first.');
    }
    params.validate(); // S5
    WireGuard.checkPromptBody(prompt); // S5
    final p = _process!;
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
    // The engine emits __DONE__ after honoring __STOP__ (verified in main.cpp),
    // which closes the stream; guard against a wedged engine that never acks.
    _stopTimer = Timer(stopTimeout, () {
      if (_state != EngineState.generating) return;
      _tokens?.addError(_fail(EngineFailure.crash, 'stop() not acknowledged'));
      _finishResponse();
    });
  }

  @override
  Future<void> dispose() async {
    _stopTimer?.cancel();
    await _stdoutSub?.cancel();
    _stdoutSub = null;
    final p = _process;
    _process = null; // clear first so _onExit treats this as a clean dispose.
    p?.kill();
    // Don't leave a load awaiter hanging until the timeout if we tear down mid-load.
    if (!(_loaded?.isCompleted ?? true)) {
      _loaded!.completeError(StateError('Engine disposed during load.'));
      _loaded!.future.ignore(); // suppress unhandled-error if no one is awaiting.
    }
    await _tokens?.close();
    _tokens = null;
    _state = EngineState.idle;
    if (p != null) await p.exitCode; // reap so a respawn can't double-bind the GPU.
  }

  // --- internals --------------------------------------------------------------

  void _onReady() {
    _state = EngineState.ready;
    if (!(_loaded?.isCompleted ?? true)) _loaded!.complete();
  }

  void _finishResponse() {
    _stopTimer?.cancel();
    _state = EngineState.ready;
    _tokens?.close();
    _tokens = null;
  }

  EngineException _fail(EngineFailure kind, String message, {int? exitCode}) =>
      EngineException(kind, message, exitCode: exitCode, stderrTail: _stderr.tail);

  void _onError(Object e, StackTrace st) {
    _state = EngineState.error;
    _tokens?.addError(e, st);
    if (!(_loaded?.isCompleted ?? true)) _loaded!.completeError(e, st);
  }

  // Fires on real process death; the clean dispose() path nulls _process first.
  void _onExit(int code) {
    if (_process == null) return;
    if (_state == EngineState.generating) {
      _tokens?.addError(
          _fail(EngineFailure.crash, 'Engine exited during generation', exitCode: code));
      _finishResponse();
    } else if (!(_loaded?.isCompleted ?? true)) {
      _loaded!.completeError(
          _fail(EngineFailure.crash, 'Engine exited before model load', exitCode: code));
    }
    _process = null;
    _state = EngineState.idle;
  }
}
