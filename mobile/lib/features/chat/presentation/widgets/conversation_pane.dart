import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/chat_controller.dart';
import 'chat_composer.dart';
import 'chat_empty_state.dart';
import 'chat_header.dart';
import 'message_bubble.dart';

/// The active conversation: a header, the scrolling message list with a live
/// streaming bubble, and the composer. Used on every form factor.
class ConversationPane extends ConsumerStatefulWidget {
  const ConversationPane({super.key, this.onMenu});

  /// Shown as a leading menu button on phone to open the conversation drawer.
  final VoidCallback? onMenu;

  @override
  ConsumerState<ConversationPane> createState() => _ConversationPaneState();
}

class _ConversationPaneState extends ConsumerState<ConversationPane> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _input.text;
    _input.clear();
    ref.read(chatControllerProvider.notifier).send(text);
  }

  void _toBottom() {
    if (!_scroll.hasClients) return;
    _scroll.jumpTo(_scroll.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatControllerProvider);
    final hasStreaming = state.isGenerating || state.streaming.isNotEmpty;
    final isEmpty = state.messages.isEmpty && !hasStreaming;
    WidgetsBinding.instance.addPostFrameCallback((_) => _toBottom());

    return Column(
      children: [
        ChatHeader(onMenu: widget.onMenu),
        const Divider(height: 1),
        Expanded(
          child: isEmpty
              ? ChatEmptyState(onPick: (p) => _input.text = p)
              : ListView(
                  controller: _scroll,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    for (final m in state.messages)
                      MessageBubble(text: m.text, isPrompt: m.isPrompt),
                    if (hasStreaming)
                      MessageBubble(text: state.streaming, isPrompt: false),
                  ],
                ),
        ),
        ChatComposer(
          controller: _input,
          isGenerating: state.isGenerating,
          onSubmit: _submit,
          onStop: () => ref.read(chatControllerProvider.notifier).stop(),
        ),
      ],
    );
  }
}
