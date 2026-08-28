import 'dart:io';

import 'package:phoenix_core/phoenix_core.dart';
import 'package:phoenix_server/phoenix_server.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  sqfliteFfiInit();
  final env = Platform.environment;
  final portRaw = env['PHOENIX_GATEWAY_PORT'];
  if (portRaw == null || portRaw.isEmpty) {
    stderr.writeln('PHOENIX_GATEWAY_PORT is required (set in root .env)');
    exitCode = 64;
    return;
  }
  final port = int.parse(portRaw);
  final dbPath = env['PHOENIX_DB_PATH'] ?? 'phoenix.db';
  final enginePath =
      env['PHOENIX_ENGINE_PATH'] ?? 'engine/local_provider/linux_llama/applocal_provider';

  final core = await PhoenixCore.open(
    dbPath: dbPath,
    databaseFactory: databaseFactoryFfi,
    enginePath: enginePath,
  );

  final apiKey = env['PHOENIX_GATEWAY_API_KEY'];
  final server = await io.serve(
    buildGatewayHandler(core, apiKey: apiKey),
    InternetAddress.loopbackIPv4,
    port,
  );
  final keyState = (apiKey == null || apiKey.isEmpty)
      ? 'OPEN — set PHOENIX_GATEWAY_API_KEY to require a key'
      : 'API key required';
  stdout.writeln(
    'Phoenix gateway · http://${server.address.host}:${server.port} '
    '(models + /v1/chat/completions + /v1/messages) · $keyState',
  );
}
