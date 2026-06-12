import 'package:phoenix/core/ai/inference_port.dart';
import 'package:phoenix/core/storage/database.dart';
import 'package:phoenix/features/chat/data/sqflite_chat_repository.dart';
import 'package:phoenix/features/chat/domain/entities/conversation.dart';
import 'package:phoenix/features/chat/domain/entities/message.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

/// Exercises the real SQLite schema (legacy-compatible) via the FFI backend so
/// it runs headless on desktop/CI without a Flutter engine.
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('round-trips a conversation + messages through the real schema', () async {
    final db = await PhoenixDatabase.open(inMemoryDatabasePath, databaseFactoryFfi);
    final repo = SqfliteChatRepository(db);

    final id = await repo.createConversation(Conversation(
      title: 'First chat',
      date: DateTime(2026, 6, 11),
      params: const InferenceParams(temperature: 0.3),
    ));

    await repo.addMessage(Message(
        conversationId: id, text: 'hi', date: DateTime(2026), isPrompt: true));
    await repo.addMessage(Message(
        conversationId: id, text: 'hello', date: DateTime(2026), isPrompt: false));

    final convs = await repo.conversations();
    expect(convs.single.title, 'First chat');
    expect(convs.single.params.temperature, 0.3);

    final msgs = await repo.messages(id);
    expect(msgs.map((m) => m.text), ['hi', 'hello']);
    expect(msgs.first.isPrompt, isTrue);

    await db.close();
  });
}
