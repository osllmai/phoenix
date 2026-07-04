import 'dart:convert';

import 'package:phoenix_core/phoenix_core.dart';
import 'package:phoenix_server/phoenix_server.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

class _FakeEngine implements InferencePort {
  _FakeEngine({this.tokens = const ['Hello', '!']});

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

  test('POST /v1/chat/completions without model → 409', () async {
    final res = await call('POST', '/v1/chat/completions', {
      'messages': [{'role': 'user', 'content': 'Hi'}],
    });
    expect(res.statusCode, 409);
  });

  test('POST /v1/chat/completions returns assistant message', () async {
    await addAndSelect('Llama', '/m/llama.gguf');
    final res = await call('POST', '/v1/chat/completions', {
      'messages': [{'role': 'user', 'content': 'Hello'}],
    });
    expect(res.statusCode, 200);
    final j = await jsonOf(res);
    expect(j['object'], 'chat.completion');
    expect(j['choices'][0]['message']['content'], 'Hello!');
  });

  test('POST /v1/chat/completions auto-selects by model name', () async {
    await call('POST', '/v1/models', {'name': 'Qwen', 'path': '/m/qwen.gguf'});
    final res = await call('POST', '/v1/chat/completions', {
      'model': 'Qwen',
      'messages': [{'role': 'user', 'content': 'Ping'}],
    });
    expect(res.statusCode, 200);
    expect((await jsonOf(res))['model'], 'Qwen');
  });

  test('POST /v1/chat/completions unknown model → 404', () async {
    final res = await call('POST', '/v1/chat/completions', {
      'model': 'missing',
      'messages': [{'role': 'user', 'content': 'Hi'}],
    });
    expect(res.statusCode, 404);
  });

  test('POST /v1/chat/completions streams SSE chunks', () async {
    await addAndSelect('Llama', '/m/llama.gguf');
    final res = await call('POST', '/v1/chat/completions', {
      'stream': true,
      'messages': [{'role': 'user', 'content': 'Hi'}],
    });
    expect(res.statusCode, 200);
    expect(res.headers['content-type'], contains('text/event-stream'));
    final body = await res.readAsString();
    expect(body, contains('"delta":{"content":"Hello"}'));
    expect(body, contains('data: [DONE]'));
  });

  test('POST /v1/chat/completions empty messages → 400', () async {
    final res = await call('POST', '/v1/chat/completions', {'messages': []});
    expect(res.statusCode, 400);
  });
}
