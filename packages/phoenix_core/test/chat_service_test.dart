import 'package:phoenix_core/phoenix_core.dart';
import 'package:test/test.dart';

/// Deterministic fake engine: replays a fixed token list, records the params.
class FakeEngine implements InferencePort {
  FakeEngine(this._tokens);
  final List<String> _tokens;
  InferenceParams? lastParams;
  EngineState _state = EngineState.ready;

  @override
  EngineState get state => _state;

  @override
  Future<void> loadModel(String modelPath) async => _state = EngineState.ready;

  @override
  Stream<String> prompt(String prompt, {InferenceParams params = const InferenceParams()}) async* {
    lastParams = params;
    for (final t in _tokens) {
      yield t;
    }
  }

  @override
  Future<void> stop() async => _state = EngineState.stopped;

  @override
  Future<void> dispose() async {}
}

void main() {
  late InMemoryChatRepository repo;
  late ChatService service;

  setUp(() {
    repo = InMemoryChatRepository();
  });

  test('streams tokens and persists both user + response messages', () async {
    service = ChatService(engine: FakeEngine(['Hello', ', ', 'world']), repository: repo);
    final convId = await repo.createConversation(
      Conversation(title: 'T', date: DateTime(2026)),
    );
    final conv = (await repo.conversations()).single;

    final streamed = await service.send(conv, 'hi').toList();
    expect(streamed.join(), 'Hello, world');

    final history = await service.history(convId);
    expect(history.length, 2);
    expect(history[0].isPrompt, isTrue);
    expect(history[0].text, 'hi');
    expect(history[1].isPrompt, isFalse);
    expect(history[1].text, 'Hello, world');
  });

  test('passes the conversation params through to the engine', () async {
    final engine = FakeEngine(['x']);
    service = ChatService(engine: engine, repository: repo);
    await repo.createConversation(Conversation(
      title: 'T',
      date: DateTime(2026),
      params: const InferenceParams(temperature: 0.2, maxTokens: 99),
    ));
    final conv = (await repo.conversations()).single;

    await service.send(conv, 'hi').drain<void>();
    expect(engine.lastParams?.temperature, 0.2);
    expect(engine.lastParams?.maxTokens, 99);
  });

  test('sending to an unpersisted conversation throws', () {
    service = ChatService(engine: FakeEngine([]), repository: repo);
    expect(
      () => service.send(Conversation(title: 'T', date: DateTime(2026)), 'hi').toList(),
      throwsArgumentError,
    );
  });
}
