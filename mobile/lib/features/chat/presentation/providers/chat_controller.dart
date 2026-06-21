import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:phoenix_core/phoenix_core.dart';

import 'chat_providers.dart';
import 'chat_state.dart';

part 'chat_controller.g.dart';

/// Drives a chat session: appends the user message, streams the model response
/// into a live bubble, then commits it. Reference for the `@riverpod` Notifier
/// pattern every feature controller follows.
@riverpod
class ChatController extends _$ChatController {
  late final ChatService _service;
  Conversation? _conversation;

  @override
  ChatState build() {
    _service = ref.watch(chatServiceProvider);
    return const ChatState();
  }

  Future<void> _ensureConversation() async {
    if (_conversation != null) return;
    final repo = ref.read(chatRepositoryProvider);
    final id = await repo.createConversation(
      Conversation(title: 'New chat', date: DateTime.now()),
    );
    _conversation = (await repo.conversations()).firstWhere((c) => c.id == id);
  }

  /// Loads an existing conversation's history into the pane.
  Future<void> open(Conversation conversation) async {
    _conversation = conversation;
    final repo = ref.read(chatRepositoryProvider);
    state = state.copyWith(
      messages: await repo.messages(conversation.id!),
      streaming: '',
    );
  }

  /// Starts a fresh, empty conversation.
  void newChat() {
    _conversation = null;
    state = const ChatState();
  }

  /// Sends [text] and streams the response into [ChatState.streaming].
  Future<void> send(String text) async {
    if (state.isGenerating || text.trim().isEmpty) return;
    await _ensureConversation();
    final conv = _conversation!;
    final userMsg = Message(
      conversationId: conv.id!,
      text: text.trim(),
      date: DateTime.now(),
      isPrompt: true,
    );
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isGenerating: true,
      streaming: '',
    );

    final buffer = StringBuffer();
    try {
      await for (final token in _service.send(conv, text.trim())) {
        buffer.write(token);
        state = state.copyWith(streaming: buffer.toString());
      }
    } finally {
      final response = Message(
        conversationId: conv.id!,
        text: buffer.toString().trim(),
        date: DateTime.now(),
        isPrompt: false,
      );
      state = state.copyWith(
        messages: [...state.messages, response],
        streaming: '',
        isGenerating: false,
      );
    }
  }

  Future<void> stop() async {
    await _service.stop();
    state = state.copyWith(isGenerating: false);
  }
}
