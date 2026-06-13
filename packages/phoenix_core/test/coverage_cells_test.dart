import 'package:phoenix_core/phoenix_core.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

/// Fills the plain coverage cells: empty reads, like persistence, bad input,
/// and the facade lifecycle (open/dispose).
class _ReadyEngine implements InferencePort {
  @override
  EngineState get state => EngineState.ready;
  @override
  Future<void> loadModel(String p) async {}
  @override
  Stream<String> prompt(String p, {InferenceParams params = const InferenceParams()}) =>
      const Stream.empty();
  @override
  Future<void> stop() async {}
  @override
  Future<void> dispose() async {}
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('history is empty for an unknown conversation', () async {
    final svc =
        ChatService(engine: _ReadyEngine(), repository: InMemoryChatRepository());
    expect(await svc.history(999), isEmpty);
  });

  test('models.list is empty on first run', () async {
    final m =
        ModelManager(engine: _ReadyEngine(), repository: InMemoryModelRepository());
    expect(await m.list(), isEmpty);
  });

  test('setLiked persists', () async {
    final m =
        ModelManager(engine: _ReadyEngine(), repository: InMemoryModelRepository());
    final model = await m.addLocal(name: 'L', path: '/l.gguf');
    await m.setLiked(model, true);
    expect((await m.list()).single.isLiked, isTrue);
  });

  test('addLocal rejects empty name or path', () async {
    final m =
        ModelManager(engine: _ReadyEngine(), repository: InMemoryModelRepository());
    expect(() => m.addLocal(name: '', path: '/l.gguf'), throwsArgumentError);
    expect(() => m.addLocal(name: 'L', path: ''), throwsArgumentError);
  });

  test('open() requires an engine or enginePath', () {
    expect(
      () => PhoenixCore.open(
          dbPath: inMemoryDatabasePath, databaseFactory: databaseFactoryFfi),
      throwsArgumentError,
    );
  });

  test('dispose() is idempotent', () async {
    final core = await PhoenixCore.open(
      dbPath: inMemoryDatabasePath,
      databaseFactory: databaseFactoryFfi,
      engine: _ReadyEngine(),
    );
    await core.dispose();
    await core.dispose(); // no throw
  });
}
