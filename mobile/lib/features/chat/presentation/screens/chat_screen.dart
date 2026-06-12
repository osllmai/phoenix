import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/presentation/providers/model_providers.dart';
import '../providers/chat_controller.dart';
import '../widgets/message_bubble.dart';

/// The main chat surface: history + a live streaming bubble + composer.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _input.text;
    _input.clear();
    ref.read(chatControllerProvider.notifier).send(text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatControllerProvider);
    final hasStreaming = state.isGenerating || state.streaming.isNotEmpty;

    final active = ref.watch(activeModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(active == null ? '🔥 Phoenix' : '🔥 ${active.name}'),
        actions: [
          IconButton(
            tooltip: 'Models',
            icon: const Icon(Icons.dns_outlined),
            onPressed: () => context.push('/models'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                for (final m in state.messages)
                  MessageBubble(text: m.text, isPrompt: m.isPrompt),
                if (hasStreaming)
                  MessageBubble(text: state.streaming, isPrompt: false),
              ],
            ),
          ),
          _Composer(
            controller: _input,
            isGenerating: state.isGenerating,
            onSubmit: _submit,
            onStop: () => ref.read(chatControllerProvider.notifier).stop(),
          ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.isGenerating,
    required this.onSubmit,
    required this.onStop,
  });

  final TextEditingController controller;
  final bool isGenerating;
  final VoidCallback onSubmit;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onSubmit(),
              decoration: const InputDecoration(
                hintText: 'Message Phoenix…',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          isGenerating
              ? IconButton.filled(onPressed: onStop, icon: const Icon(Icons.stop))
              : IconButton.filled(onPressed: onSubmit, icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
