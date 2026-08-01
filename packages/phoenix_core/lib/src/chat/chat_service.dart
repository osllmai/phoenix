import '../engine/device_capabilities.dart';
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
  ChatService({
    required this.engine,
    required this.repository,
    this.capabilities,
  });

  final InferencePort engine;
  final ChatRepository repository;

  /// Supplies the current device capabilities so per-prompt params are clamped
  /// to what the hardware can do (no GPU → 0 offload layers). Null = no clamp.
  final DeviceCapabilities? Function()? capabilities;

  bool _aborting = false;

  /// Sends [text] within [conversation] and streams the response tokens.
  ///
  /// Side effects: the user message is saved before generation; the response is
  /// saved once the stream ends. If stop()/an engine error cuts it short, the
  /// partial text is still saved with status `aborted` (S7), then the error
  /// (if any) rethrows.
  Stream<String> send(Conversation conversation, String text) async* {
    final convId = conversation.id;
    if (convId == null) {
      throw ArgumentError('Conversation must be persisted before sending.');
    }
    _aborting = false;
    await repository.addMessage(Message(
        conversationId: convId, text: text, date: _now(), isPrompt: true));

    final buffer = StringBuffer();
    var settled = false;
    Future<void> settle(MessageStatus s) async {
      if (settled) return;
      settled = true;
      await _persistResponse(convId, buffer, s);
    }

    final caps = capabilities?.call();
    final params = caps == null
        ? conversation.params
        : conversation.params.clampedTo(caps);

    try {
      await for (final token in engine.prompt(text, params: params)) {
        buffer.write(token);
        yield token;
      }
      await settle(_aborting ? MessageStatus.aborted : MessageStatus.normal);
    } catch (_) {
      await settle(MessageStatus.aborted);
      rethrow;
    } finally {
      // Halt the engine + persist the partial if the consumer cancelled the
      // stream (no throw, no normal end) — otherwise the engine leaks generating.
      await engine.stop();
      await settle(MessageStatus.aborted);
    }
  }

  Future<void> _persistResponse(int convId, StringBuffer buf, MessageStatus s) =>
      repository.addMessage(Message(
          conversationId: convId,
          text: buf.toString().trim(),
          date: _now(),
          isPrompt: false,
          status: s));

  /// Stops the in-flight generation; its partial response persists as aborted.
  Future<void> stop() async {
    _aborting = true;
    await engine.stop();
  }

  /// Loads the message history for a conversation.
  Future<List<Message>> history(int conversationId) =>
      repository.messages(conversationId);

  // Injected indirectly so tests can stay deterministic; real clock by default.
  DateTime _now() => DateTime.now();
}
