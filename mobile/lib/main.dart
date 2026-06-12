import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app/app.dart';
import 'core/storage/database.dart';
import 'features/chat/data/sqflite_chat_repository.dart';
import 'features/chat/presentation/providers/chat_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Desktop uses the FFI SQLite backend.
  sqfliteFfiInit();
  final dir = await getApplicationSupportDirectory();
  final db = await PhoenixDatabase.open(p.join(dir.path, 'phoenix.db'), databaseFactoryFfi);

  runApp(
    ProviderScope(
      overrides: [
        chatRepositoryProvider.overrideWithValue(SqfliteChatRepository(db)),
      ],
      child: const PhoenixApp(),
    ),
  );
}
