import 'dart:async';

import 'package:phoenix_core/phoenix_core.dart';
import 'package:test/test.dart';

/// S7 — when a generation is cut short (engine error or stop()), the user
/// message AND the partial assistant text are persisted, the latter marked
/// `aborted`.

/// Yields two tokens then fails.
class _ThrowingEngine implements InferencePort {
  @override
  EngineState get state => EngineState.ready;
  @override
  Future<void> loadModel(String p) async {}
  @override
  Stream<String> prompt(String p, {InferenceParams params = const InferenceParams()}) async* {
    yield 'par';
    yield 'tial';
    throw EngineException(EngineFailure.crash, 'boom');
  }
  @override
  Future<void> stop() async {}
  @override
  Future<void> dispose() async {}
}

/// Emits on demand; stop() closes the stream (mirrors the engine's __DONE__).
class _ControllableEngine implements InferencePort {
  final _ctrl = StreamController<String>();
  bool stopped = false;
  @override
  EngineState get state => EngineState.generating;
  @override
  Future<void> loadModel(String p) async {}
  @override
  Stream<String> prompt(String p, {InferenceParams params = const InferenceParams()}) => _ctrl.stream;
  @override
  Future<void> stop() async {
    stopped = true;
    // Non-blocking like the real engine — never await close from inside cancel.
    if (!_ctrl.isClosed) unawaited(_ctrl.close());
  }
  @override
  Future<void> dispose() async {}
  void emit(String t) => _ctrl.add(t);
}

void main() {
  late InMemoryChatRepository repo;
  setUp(() => repo = InMemoryChatRepository());

  Future<(int, Conversation)> seed() async {
    final id = await repo.createConversation(
        Conversation(title: 'T', date: DateTime(2026)));
    return (id, (await repo.conversations()).single);
  }

  test('engine error persists the partial response as aborted', () async {
    final svc = ChatService(engine: _ThrowingEngine(), repository: repo);
    final (id, conv) = await seed();

    await expectLater(
        svc.send(conv, 'hi').toList(), throwsA(isA<EngineException>()));

    final hist = await svc.history(id);
    expect(hist.length, 2);
    expect(hist[0].text, 'hi');
    expect(hist[1].isPrompt, isFalse);
    expect(hist[1].text, 'partial');
    expect(hist[1].status, MessageStatus.aborted);
  });

  test('stop() persists the partial response as aborted', () async {
    final eng = _ControllableEngine();
    final svc = ChatService(engine: eng, repository: repo);
    final (id, conv) = await seed();

    final collected = <String>[];
    final sub = svc.send(conv, 'hi').listen(collected.add);
    await Future<void>.delayed(const Duration(milliseconds: 10)); // send subscribes
    eng.emit('par');
    eng.emit('tial');
    await Future<void>.delayed(const Duration(milliseconds: 10)); // tokens consumed
    await svc.stop(); // sets aborting + closes the stream
    await sub.asFuture<void>();

    final hist = await svc.history(id);
    expect(collected, ['par', 'tial']);
    expect(hist.length, 2);
    expect(hist[1].text, 'partial');
    expect(hist[1].status, MessageStatus.aborted);
  });

  test('consumer cancellation stops the engine and persists aborted', () async {
    final eng = _StreamingEngine();
    final svc = ChatService(engine: eng, repository: repo);
    final (id, conv) = await seed();

    final got = <String>[];
    final sub = svc.send(conv, 'hi').listen(got.add);
    await Future<void>.delayed(const Duration(milliseconds: 30)); // tokens flow
    await sub.cancel(); // observed on the next emit → send()'s finally runs

    final hist = await svc.history(id);
    expect(got, isNotEmpty);
    expect(eng.stopped, isTrue);
    expect(hist.length, 2);
    expect(hist[1].text, isNotEmpty);
    expect(hist[1].status, MessageStatus.aborted);
  });
}

/// Streams tokens on a timer (like a real generating engine), so a consumer
/// cancel is observed promptly by the `await for`.
class _StreamingEngine implements InferencePort {
  StreamController<String>? _ctrl;
  Timer? _timer;
  bool stopped = false;
  int _n = 0;
  @override
  EngineState get state => EngineState.generating;
  @override
  Future<void> loadModel(String p) async {}
  @override
  Stream<String> prompt(String p, {InferenceParams params = const InferenceParams()}) {
    final c = StreamController<String>();
    _ctrl = c;
    _timer = Timer.periodic(
        const Duration(milliseconds: 5), (_) => c.isClosed ? null : c.add('t${_n++}'));
    return c.stream;
  }
  @override
  Future<void> stop() async {
    stopped = true;
    _timer?.cancel();
    if (!(_ctrl?.isClosed ?? true)) unawaited(_ctrl!.close());
  }
  @override
  Future<void> dispose() async => _timer?.cancel();
}
