import '../domain/entities/conversation.dart';
import '../domain/entities/message.dart';

/// Persistence contract for chat. Implemented by [SqfliteChatRepository] in the
/// app and an in-memory fake in tests — so ChatService is testable without a DB.
abstract interface class ChatRepository {
  Future<int> createConversation(Conversation conversation);
  Future<List<Conversation>> conversations();
  Future<int> addMessage(Message message);
  Future<List<Message>> messages(int conversationId);
}

/// Lightweight in-memory implementation for tests and previews.
class InMemoryChatRepository implements ChatRepository {
  final _conversations = <Conversation>[];
  final _messages = <Message>[];
  int _convSeq = 0;
  int _msgSeq = 0;

  @override
  Future<int> createConversation(Conversation conversation) async {
    final id = ++_convSeq;
    _conversations.add(conversation.copyWith(id: id));
    return id;
  }

  @override
  Future<List<Conversation>> conversations() async =>
      List.unmodifiable(_conversations);

  @override
  Future<int> addMessage(Message message) async {
    final id = ++_msgSeq;
    _messages.add(message.copyWith(id: id));
    return id;
  }

  @override
  Future<List<Message>> messages(int conversationId) async => _messages
      .where((m) => m.conversationId == conversationId)
      .toList(growable: false);
}
