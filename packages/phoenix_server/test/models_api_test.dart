import 'dart:convert';

import 'package:phoenix_core/phoenix_core.dart';
import 'package:phoenix_server/phoenix_server.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

class _FakeEngine implements InferencePort {
  @override
  EngineState get state => EngineState.idle;
  @override
  Future<void> loadModel(String modelPath) async {}
  @override
  Stream<String> prompt(String prompt, {InferenceParams params = const InferenceParams()}) =>
      const Stream.empty();
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

  test('GET /v1/models — empty + CORS header', () async {
    final res = await call('GET', '/v1/models');
    expect(res.statusCode, 200);
    expect(res.headers['access-control-allow-origin'], '*');
    final j = await jsonOf(res);
    expect(j['data'], isEmpty);
    expect(j['active'], isNull);
  });

  test('POST /v1/models adds, then list shows it', () async {
    final add = await call('POST', '/v1/models', {'name': 'Llama', 'path': '/m/llama.gguf'});
    expect(add.statusCode, 201);
    final list = await jsonOf(await call('GET', '/v1/models'));
    expect(list['data'], hasLength(1));
    expect(list['data'][0]['name'], 'Llama');
    expect(list['data'][0]['installed'], isTrue);
  });

  test('POST /v1/models with empty name/path → 400', () async {
    final res = await call('POST', '/v1/models', {'name': '', 'path': ''});
    expect(res.statusCode, 400);
  });

  test('select makes the model active', () async {
    final id = (await jsonOf(await call('POST', '/v1/models', {'name': 'Q', 'path': '/m/q.gguf'})))['id'];
    final sel = await call('POST', '/v1/models/$id/select');
    expect(sel.statusCode, 200);
    expect((await jsonOf(await call('GET', '/v1/models')))['active']['name'], 'Q');
  });

  test('like toggles persisted flag', () async {
    final id = (await jsonOf(await call('POST', '/v1/models', {'name': 'M', 'path': '/m/m.gguf'})))['id'];
    await call('POST', '/v1/models/$id/like', {'liked': true});
    expect((await jsonOf(await call('GET', '/v1/models')))['data'][0]['liked'], isTrue);
  });

  test('delete removes it', () async {
    final id = (await jsonOf(await call('POST', '/v1/models', {'name': 'X', 'path': '/m/x.gguf'})))['id'];
    expect((await call('DELETE', '/v1/models/$id')).statusCode, 200);
    expect((await jsonOf(await call('GET', '/v1/models')))['data'], isEmpty);
  });

  test('unknown id → 404', () async {
    expect((await call('POST', '/v1/models/999/select')).statusCode, 404);
  });
}
