import 'dart:io';

import 'package:phoenix_core/phoenix_core.dart';
import 'package:phoenix_server/phoenix_server.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Mock engine for automated end-to-end HTTP smoke tests.
class E2eMockEngine implements InferencePort {
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
    for (final part in ['The capital of France is ', 'Paris', '.']) {
      yield part;
    }
    _state = EngineState.ready;
  }

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}
}

/// Serves the gateway with [E2eMockEngine] on [PHOENIX_E2E_PORT] (default 24779).
Future<void> main() async {
  sqfliteFfiInit();
  final port = int.tryParse(Platform.environment['PHOENIX_E2E_PORT'] ?? '') ?? 24779;
  final core = await PhoenixCore.open(
    dbPath: inMemoryDatabasePath,
    databaseFactory: databaseFactoryFfi,
    engine: E2eMockEngine(),
  );
  final server = await io.serve(
    buildGatewayHandler(core),
    InternetAddress.loopbackIPv4,
    port,
  );
  stdout.writeln('phoenix-e2e-ready ${server.port}');
}
