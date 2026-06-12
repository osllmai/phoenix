import 'package:sqflite_common/sqlite_api.dart';

import 'chat/chat_service.dart';
import 'chat/sqflite_chat_repository.dart';
import 'engine/inference_port.dart';
import 'engine/subprocess_engine.dart';
import 'models/model_manager.dart';
import 'models/sqflite_model_repository.dart';
import 'storage/database.dart';

/// The single entry point to the Phoenix core (the SDK facade).
///
/// Composes the engine, persistence, and services. UI/server/CLI all depend on
/// this — never on the concrete engine or repositories.
///
/// ```dart
/// final core = await PhoenixCore.open(
///   enginePath: 'resources/providers/local_provider/applocal_provider',
///   dbPath: '/data/phoenix.db',
///   databaseFactory: databaseFactoryFfi,
/// );
/// await core.models.select(await core.models.addLocal(name: 'Llama', path: '/m.gguf'));
/// await for (final t in core.chat.send(conversation, 'Hi')) stdout.write(t);
/// ```
class PhoenixCore {
  PhoenixCore._({
    required this.engine,
    required this.chat,
    required this.models,
    required PhoenixDatabase database,
  }) : _database = database;

  /// The on-device inference engine (llama.cpp subprocess by default).
  final InferencePort engine;

  /// Multi-turn chat orchestration (engine + persistence + streaming).
  final ChatService chat;

  /// Installed-model catalog + active-model selection.
  final ModelManager models;

  final PhoenixDatabase _database;

  /// Opens the core: database + engine + services, ready to use.
  ///
  /// [engine] may be injected (tests / alternative backends); otherwise a
  /// [SubprocessEngine] is created from [enginePath].
  static Future<PhoenixCore> open({
    required String dbPath,
    required DatabaseFactory databaseFactory,
    String? enginePath,
    InferencePort? engine,
  }) async {
    assert(engine != null || enginePath != null,
        'Provide either an engine or an enginePath.');
    final db = await PhoenixDatabase.open(dbPath, databaseFactory);
    final port = engine ?? SubprocessEngine(executablePath: enginePath!);
    return PhoenixCore._(
      engine: port,
      chat: ChatService(engine: port, repository: SqfliteChatRepository(db)),
      models: ModelManager(engine: port, repository: SqfliteModelRepository(db)),
      database: db,
    );
  }

  /// Releases the engine process and closes the database.
  Future<void> dispose() async {
    await engine.dispose();
    await _database.close();
  }
}
