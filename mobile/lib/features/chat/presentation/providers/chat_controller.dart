import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/chat_service.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import 'chat_providers.dart';

/// UI state for a single chat session.
class ChatState {
  const ChatState({
    this.messages = const [],
    this.streaming = '',
    this.isGenerating = false,
  });

  final List<Message> messages;

  /// The in-flight response text being streamed (shown as a live bubble).
  final String streaming;
  final bool isGenerating;

  ChatState copyWith({List<Message>? messages, String? streaming, bool? isGenerating}) =>
      ChatState(
        messages: messages ?? this.messages,
        streaming: streaming ?? this.streaming,
        isGenerating: isGenerating ?? this.isGenerating,
      );
}

/// Drives a chat session: holds the conversation, appends the user message,
/// streams the model response into a live bubble, then commits it to history.
class ChatController extends Notifier<ChatState> {
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

final chatControllerProvider =
    NotifierProvider<ChatController, ChatState>(ChatController.new);
