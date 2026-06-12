import '../storage/database.dart';
import 'conversation.dart';
import 'message.dart';
import 'chat_repository.dart';

/// SQLite-backed [ChatRepository] using the legacy-compatible schema.
class SqfliteChatRepository implements ChatRepository {
  SqfliteChatRepository(this._db);

  final PhoenixDatabase _db;

  @override
  Future<int> createConversation(Conversation conversation) =>
      _db.db.insert('conversation', conversation.toRow());

  @override
  Future<List<Conversation>> conversations() async {
    final rows = await _db.db.query('conversation', orderBy: 'date DESC');
    return rows.map(Conversation.fromRow).toList(growable: false);
  }

  @override
  Future<int> addMessage(Message message) =>
      _db.db.insert('message', message.toRow());

  @override
  Future<List<Message>> messages(int conversationId) async {
    final rows = await _db.db.query(
      'message',
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
      orderBy: 'id ASC',
    );
    return rows.map(Message.fromRow).toList(growable: false);
  }
}
