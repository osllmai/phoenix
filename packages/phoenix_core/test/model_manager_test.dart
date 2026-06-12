import 'package:phoenix_core/phoenix_core.dart';
import 'package:test/test.dart';

/// Records which model path was loaded into the engine.
class RecordingEngine implements InferencePort {
  String? loadedPath;
  @override
  EngineState get state => EngineState.ready;
  @override
  Future<void> loadModel(String modelPath) async => loadedPath = modelPath;
  @override
  Stream<String> prompt(String p, {InferenceParams params = const InferenceParams()}) =>
      const Stream.empty();
  @override
  Future<void> stop() async {}
  @override
  Future<void> dispose() async {}
}

void main() {
  late RecordingEngine engine;
  late ModelManager manager;

  setUp(() {
    engine = RecordingEngine();
    manager = ModelManager(engine: engine, repository: InMemoryModelRepository());
  });

  test('addLocal persists and select loads the model into the engine', () async {
    final m = await manager.addLocal(name: 'Llama 3.2 3B', path: '/models/llama.gguf');
    expect(m.id, isNotNull);
    expect((await manager.list()).single.name, 'Llama 3.2 3B');

    await manager.select(m);
    expect(engine.loadedPath, '/models/llama.gguf');
    expect(manager.active?.id, m.id);
  });

  test('selecting a model with no file throws', () {
    const m = AiModel(id: 1, name: 'ghost');
    expect(() => manager.select(m), throwsArgumentError);
  });

  test('removing the active model clears active', () async {
    final m = await manager.addLocal(name: 'x', path: '/x.gguf');
    await manager.select(m);
    await manager.remove(m);
    expect(manager.active, isNull);
    expect(await manager.list(), isEmpty);
  });
}
