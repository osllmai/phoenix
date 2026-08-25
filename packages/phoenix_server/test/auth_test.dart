import 'dart:convert';

import 'package:phoenix_core/phoenix_core.dart';
import 'package:phoenix_server/phoenix_server.dart';
import 'package:shelf/shelf.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
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

  setUp(() async {
    core = await PhoenixCore.open(
      dbPath: inMemoryDatabasePath,
      databaseFactory: databaseFactoryFfi,
      engine: _FakeEngine(),
    );
  });

  tearDown(() => core.dispose());

  Future<Response> call(
    Handler handler,
    String method,
    String path, {
    Map<String, String> headers = const {},
  }) async => handler(Request(method, Uri.parse('http://localhost$path'), headers: headers));

  group('no key configured — the gateway stays open', () {
    test('GET /v1/models passes without credentials', () async {
      final handler = buildGatewayHandler(core);
      expect((await call(handler, 'GET', '/v1/models')).statusCode, 200);
    });

    test('an empty key is treated as unset', () async {
      final handler = buildGatewayHandler(core, apiKey: '   ');
      expect((await call(handler, 'GET', '/v1/models')).statusCode, 200);
    });
  });

  group('key configured', () {
    late Handler handler;
    setUp(() => handler = buildGatewayHandler(core, apiKey: 'phx_test_key'));

    test('rejects a request with no credentials', () async {
      final res = await call(handler, 'GET', '/v1/models');
      expect(res.statusCode, 401);
      final body = jsonDecode(await res.readAsString()) as Map<String, dynamic>;
      expect((body['error'] as Map)['type'], 'authentication_error');
    });

    test('rejects a wrong key', () async {
      final res = await call(
        handler,
        'GET',
        '/v1/models',
        headers: {'authorization': 'Bearer wrong'},
      );
      expect(res.statusCode, 401);
    });

    test('accepts OpenAI-style Authorization: Bearer', () async {
      final res = await call(
        handler,
        'GET',
        '/v1/models',
        headers: {'authorization': 'Bearer phx_test_key'},
      );
      expect(res.statusCode, 200);
    });

    test('accepts Anthropic-style x-api-key', () async {
      final res = await call(
        handler,
        'GET',
        '/v1/models',
        headers: {'x-api-key': 'phx_test_key'},
      );
      expect(res.statusCode, 200);
    });

    test('/health stays open for probes', () async {
      expect((await call(handler, 'GET', '/health')).statusCode, 200);
    });

    test('CORS preflight is not blocked', () async {
      final res = await call(
        handler,
        'OPTIONS',
        '/v1/chat/completions',
        headers: {'origin': 'http://localhost:24678'},
      );
      expect(res.statusCode, lessThan(400));
    });

    test('guards the inference routes too, not just models', () async {
      expect((await call(handler, 'POST', '/v1/messages')).statusCode, 401);
      expect((await call(handler, 'POST', '/v1/chat/completions')).statusCode, 401);
    });
  });
}
