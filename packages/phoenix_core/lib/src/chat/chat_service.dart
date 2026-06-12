import '../engine/inference_port.dart';
import 'chat_repository.dart';
import 'conversation.dart';
import 'message.dart';

/// Orchestrates a chat turn: persist the user prompt, stream the model response
/// from the [InferencePort], then persist the assembled response.
///
/// This is the Dart equivalent of the legacy `TextConversation` + provider glue,
/// but engine-agnostic — it depends only on [InferencePort] and [ChatRepository].
class ChatService {
  ChatService({required this.engine, required this.repository});

  final InferencePort engine;
  final ChatRepository repository;

  /// Sends [text] within [conversation] and streams the response tokens.
  ///
  /// Side effects: the user message is saved before generation; the full
  /// response is saved once the stream completes.
  Stream<String> send(Conversation conversation, String text) async* {
    final convId = conversation.id;
    if (convId == null) {
      throw ArgumentError('Conversation must be persisted before sending.');
    }

    await repository.addMessage(Message(
      conversationId: convId,
      text: text,
      date: _now(),
      isPrompt: true,
    ));

    final buffer = StringBuffer();
    await for (final token in engine.prompt(text, params: conversation.params)) {
      buffer.write(token);
      yield token;
    }

    await repository.addMessage(Message(
      conversationId: convId,
      text: buffer.toString().trim(),
      date: _now(),
      isPrompt: false,
    ));
  }

  /// Stops the in-flight generation.
  Future<void> stop() => engine.stop();

  /// Loads the message history for a conversation.
  Future<List<Message>> history(int conversationId) =>
      repository.messages(conversationId);

  // Injected indirectly so tests can stay deterministic; real clock by default.
  DateTime _now() => DateTime.now();
}
