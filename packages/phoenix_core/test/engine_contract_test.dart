import 'dart:io';

import 'package:phoenix_core/phoenix_core.dart';
import 'package:test/test.dart';

/// The hardened engine-port contracts (S1–S4, S6, S8), driven against the mock
/// engine which speaks the real `__PROMPT__/__END__/__DONE__/__STOP__` protocol.
void main() {
  final mockPath = File('test/mock_engine.dart').absolute.path;

  SubprocessEngine make() => SubprocessEngine(
        executablePath: Platform.resolvedExecutable,
        extraArgs: ['run', mockPath],
        loadTimeout: const Duration(seconds: 30),
        stopTimeout: const Duration(seconds: 2),
      );

  test('S2: a reentrant prompt while generating throws', () async {
    final e = make();
    await e.loadModel('/m.gguf');
    final first = e.prompt('one two three four five six');
    expect(() => e.prompt('again'), throwsStateError);
    await first.toList();
    await e.dispose();
  });

  test('S3: a crash mid-generation surfaces EngineException', () async {
    final e = make();
    await e.loadModel('/tmp/CRASH.gguf');
    await expectLater(
        e.prompt('hello world').toList(), throwsA(isA<EngineException>()));
    await e.dispose();
  });

  test('S6: a model-load failure throws EngineException', () async {
    final e = make();
    await expectLater(
        e.loadModel('/tmp/LOADFAIL.gguf'), throwsA(isA<EngineException>()));
    await e.dispose();
  });

  test('S4: switching models reloads the engine', () async {
    final e = make();
    await e.loadModel('/a.gguf');
    expect(e.state, EngineState.ready);
    await e.loadModel('/b.gguf');
    expect(e.state, EngineState.ready);
    final out = await e.prompt('beta').toList();
    expect(out.join().replaceAll(RegExp(r'\s+'), ' ').trim(), 'beta');
    await e.dispose();
  });

  test('S1+S8: stop ends the stream; the next prompt streams only its tokens',
      () async {
    final e = make();
    await e.loadModel('/m.gguf');
    final collected = <String>[];
    final sub =
        e.prompt('alpha bravo charlie delta echo foxtrot golf hotel').listen(
              collected.add,
            );
    await Future<void>.delayed(const Duration(milliseconds: 8));
    await e.stop();
    await sub.asFuture<void>().catchError((_) {}); // closes on engine __DONE__
    expect(e.state, EngineState.ready);

    final clean = await e.prompt('beta').toList();
    expect(clean.join().replaceAll(RegExp(r'\s+'), ' ').trim(), 'beta');
    await e.dispose();
  });

  test('dispose during a stuck load fails the load future (no 120s hang)', () async {
    final e = make();
    final f = e.loadModel('/tmp/HANG.gguf');
    final expectation = expectLater(f, throwsA(isA<StateError>())); // attach before it errors
    await Future<void>.delayed(const Duration(milliseconds: 50)); // process up, still loading
    await e.dispose();
    await expectation;
  });
}
