import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:phoenix_core/phoenix_core.dart';

import '../providers/chat_controller.dart';
import '../providers/conversation_list_provider.dart';

/// The conversation list pane: a "New chat" action, a search filter, and the
/// saved conversations. Rendered as a side pane (tablet/desktop) or Drawer (phone).
class ConversationList extends ConsumerStatefulWidget {
  const ConversationList({super.key, this.onSelected});

  /// Called after a selection so the phone Drawer can close itself.
  final VoidCallback? onSelected;

  @override
  ConsumerState<ConversationList> createState() => _ConversationListState();
}

class _ConversationListState extends ConsumerState<ConversationList> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(chatControllerProvider.notifier);
    final convos = ref.watch(conversationListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: FilledButton.icon(
            onPressed: () {
              controller.newChat();
              widget.onSelected?.call();
            },
            icon: const Icon(Icons.add),
            label: const Text('New chat'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              isDense: true,
              hintText: 'Search conversations…',
              prefixIcon: Icon(Icons.search, size: 18),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: convos.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Failed: $e')),
            data: (list) => _list(controller, _filter(list)),
          ),
        ),
      ],
    );
  }

  List<Conversation> _filter(List<Conversation> list) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return list;
    return list.where((c) => c.title.toLowerCase().contains(q)).toList();
  }

  Widget _list(ChatController controller, List<Conversation> list) {
    if (list.isEmpty) {
      return Center(
        child: Text(_query.isEmpty ? 'No conversations yet' : 'No matches'),
      );
    }
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) => _Tile(
        conversation: list[i],
        onTap: () {
          controller.open(list[i]);
          widget.onSelected?.call();
        },
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.conversation, required this.onTap});

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.chat_bubble_outline),
      title: Text(conversation.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: onTap,
    );
  }
}
