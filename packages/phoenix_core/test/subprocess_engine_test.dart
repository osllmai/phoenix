import 'dart:io';

import 'package:test/test.dart';
import 'package:phoenix_core/phoenix_core.dart';

/// Proves the SubprocessEngine drives the real protocol end-to-end, using a mock
/// engine that speaks `__PROMPT__/__END__/__DONE_PROMPTPROCESS__`.
void main() {
  // Resolve the mock script relative to the package root.
  final mockPath = File('test/mock_engine.dart').absolute.path;

  late SubprocessEngine engine;

  setUp(() {
    engine = SubprocessEngine(
      executablePath: Platform.resolvedExecutable, // the `dart`/`flutter` VM
      extraArgs: ['run', mockPath],
    );
  });

  tearDown(() async => engine.dispose());

  test('loads model and reaches ready state', () async {
    await engine.loadModel('/fake/model.gguf');
    expect(engine.state, EngineState.ready);
  });

  test('streams tokens then closes on __DONE__', () async {
    await engine.loadModel('/fake/model.gguf');
    final out = await engine.prompt('hello world from phoenix').toList();
    final text = out.join().replaceAll(RegExp(r'\s+'), ' ').trim();
    expect(text, 'hello world from phoenix');
    expect(engine.state, EngineState.ready);
  });

  test('prompt before loadModel throws', () {
    expect(() => engine.prompt('x'), throwsStateError);
  });
}
