import 'package:sqflite_common/sqlite_api.dart';

/// Opens the Phoenix SQLite database and creates the schema.
///
/// Schema is a faithful port of the legacy Qt managers
/// (`core/database/managers/*.cpp`) so existing databases remain compatible.
class PhoenixDatabase {
  PhoenixDatabase._(this.db);

  final Database db;

  static const _conversationSql = '''
    CREATE TABLE IF NOT EXISTS conversation(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT NOT NULL DEFAULT '',
      date TEXT NOT NULL,
      icon TEXT NOT NULL DEFAULT '',
      isPinned INTEGER NOT NULL DEFAULT 0,
      type TEXT NOT NULL DEFAULT 'text',
      stream INTEGER NOT NULL DEFAULT 1,
      promptTemplate TEXT NOT NULL DEFAULT '',
      systemPrompt TEXT NOT NULL DEFAULT '',
      temperature REAL NOT NULL DEFAULT 0.7,
      topK INTEGER NOT NULL DEFAULT 40,
      topP REAL NOT NULL DEFAULT 0.95,
      minP REAL NOT NULL DEFAULT 0.05,
      repeatPenalty REAL NOT NULL DEFAULT 1.1,
      promptBatchSize INTEGER NOT NULL DEFAULT 128,
      maxTokens INTEGER NOT NULL DEFAULT 512,
      repeatPenaltyTokens INTEGER NOT NULL DEFAULT 64,
      contextLength INTEGER NOT NULL DEFAULT 4096,
      numberOfGPULayers INTEGER NOT NULL DEFAULT 0
    )''';

  static const _modelSql = '''
    CREATE TABLE IF NOT EXISTS model(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      key TEXT,
      add_model_time TEXT,
      isLike INTEGER NOT NULL DEFAULT 0
    )''';

  static const _messageSql = '''
    CREATE TABLE IF NOT EXISTS message(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      conversation_id INTEGER NOT NULL,
      text TEXT,
      fileName TEXT,
      date TEXT NOT NULL,
      icon TEXT NOT NULL,
      isPrompt INTEGER NOT NULL,
      like INTEGER NOT NULL,
      status TEXT NOT NULL DEFAULT 'normal',
      FOREIGN KEY(conversation_id) REFERENCES conversation(id) ON DELETE CASCADE
    )''';

  static const _v2AddStatus =
      "ALTER TABLE message ADD COLUMN status TEXT NOT NULL DEFAULT 'normal'";

  /// Opens the DB at [path] using [factory] and runs migrations.
  ///
  /// Desktop app and tests both pass the FFI factory (`databaseFactoryFfi`);
  /// mobile passes sqflite's native factory.
  static Future<PhoenixDatabase> open(String path, DatabaseFactory factory) async {
    final db = await factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 2,
        onConfigure: (d) => d.execute('PRAGMA foreign_keys = ON'),
        onCreate: (d, _) async {
          await d.execute(_conversationSql);
          await d.execute(_messageSql);
          await d.execute(_modelSql);
        },
        onUpgrade: (d, from, to) async {
          if (from < 2) await d.execute(_v2AddStatus);
        },
      ),
    );
    return PhoenixDatabase._(db);
  }

  Future<void> close() => db.close();
}
