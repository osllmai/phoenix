import 'dart:io';

import 'package:phoenix_core/phoenix_core.dart';
import 'package:phoenix_server/phoenix_server.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Runs the on-device gateway: model management + OpenAI-compatible chat.
Future<void> main() async {
  sqfliteFfiInit();
  final env = Platform.environment;
  final port = int.tryParse(env['PHOENIX_GATEWAY_PORT'] ?? '') ?? 24678;
  final dbPath = env['PHOENIX_DB_PATH'] ?? 'phoenix.db';
  final enginePath =
      env['PHOENIX_ENGINE_PATH'] ?? 'engine/local_provider/linux_llama/applocal_provider';

  final core = await PhoenixCore.open(
    dbPath: dbPath,
    databaseFactory: databaseFactoryFfi,
    enginePath: enginePath,
  );

  final server = await io.serve(
    buildGatewayHandler(core),
    InternetAddress.loopbackIPv4,
    port,
  );
  stdout.writeln(
    'Phoenix gateway · http://${server.address.host}:${server.port} '
    '(models + /v1/chat/completions + /v1/messages)',
  );
}
