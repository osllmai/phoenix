import 'dart:convert';

import 'package:phoenix_core/phoenix_core.dart';
import 'package:phoenix_server/phoenix_server.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

class _FakeEngine implements InferencePort {
  _FakeEngine({this.tokens = const ['Bonjour', '!']});

  final List<String> tokens;
  EngineState _state = EngineState.idle;

  @override
  EngineState get state => _state;

  @override
  Future<void> loadModel(String modelPath) async {
    _state = EngineState.ready;
  }

  @override
  Stream<String> prompt(String prompt, {InferenceParams params = const InferenceParams()}) async* {
    _state = EngineState.generating;
    for (final t in tokens) {
      yield t;
    }
    _state = EngineState.ready;
  }

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}
}

void main() {
  sqfliteFfiInit();

  late PhoenixCore core;
  late Handler handler;

  setUp(() async {
    core = await PhoenixCore.open(
      dbPath: inMemoryDatabasePath,
      databaseFactory: databaseFactoryFfi,
      engine: _FakeEngine(),
    );
    handler = buildGatewayHandler(core);
  });

  tearDown(() => core.dispose());

  Future<Response> call(String method, String path, [Object? body]) async => handler(
    Request(
      method,
      Uri.parse('http://localhost$path'),
      body: body == null ? null : jsonEncode(body),
      headers: {'content-type': 'application/json'},
    ),
  );

  Future<dynamic> jsonOf(Response r) async => jsonDecode(await r.readAsString());

  Future<void> addAndSelect(String name, String path) async {
    final id = (await jsonOf(await call('POST', '/v1/models', {'name': name, 'path': path})))['id'];
    await call('POST', '/v1/models/$id/select');
  }

  test('POST /v1/messages without model → 409', () async {
    final res = await call('POST', '/v1/messages', {
      'max_tokens': 64,
      'messages': [
        {'role': 'user', 'content': 'Hi'},
      ],
    });
    expect(res.statusCode, 409);
  });

  test('POST /v1/messages requires max_tokens', () async {
    final res = await call('POST', '/v1/messages', {
      'model': 'claude-local',
      'messages': [
        {'role': 'user', 'content': 'Hi'},
      ],
    });
    expect(res.statusCode, 400);
  });

  test('POST /v1/messages returns Anthropic message shape', () async {
    await addAndSelect('Llama', '/m/llama.gguf');
    final res = await call('POST', '/v1/messages', {
      'model': 'Llama',
      'max_tokens': 64,
      'messages': [
        {'role': 'user', 'content': 'Hello'},
      ],
    });
    expect(res.statusCode, 200);
    final j = await jsonOf(res);
    expect(j['type'], 'message');
    expect(j['role'], 'assistant');
    expect(j['content'][0]['text'], 'Bonjour!');
    expect(j['stop_reason'], 'end_turn');
  });

  test('POST /v1/messages accepts top-level system string', () async {
    await addAndSelect('Llama', '/m/llama.gguf');
    final res = await call('POST', '/v1/messages', {
      'model': 'Llama',
      'max_tokens': 64,
      'system': 'You are helpful.',
      'messages': [
        {'role': 'user', 'content': 'Hello'},
      ],
    });
    expect(res.statusCode, 200);
  });

  test('POST /v1/messages streams Anthropic SSE events', () async {
    await addAndSelect('Llama', '/m/llama.gguf');
    final res = await call('POST', '/v1/messages', {
      'model': 'Llama',
      'max_tokens': 64,
      'stream': true,
      'messages': [
        {'role': 'user', 'content': 'Hi'},
      ],
    });
    expect(res.statusCode, 200);
    expect(res.headers['content-type'], contains('text/event-stream'));
    final body = await res.readAsString();
    expect(body, contains('event: message_start'));
    expect(body, contains('content_block_delta'));
    expect(body, contains('"text":"Bonjour"'));
    expect(body, contains('event: message_stop'));
  });
}
