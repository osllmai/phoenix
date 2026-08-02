import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:phoenix_core/phoenix_core.dart';

import '../providers/chat_controller.dart';
import '../providers/conversation_list_provider.dart';

/// The collapsed conversation column: a ~60px rail with a new-chat action, a
/// search action (which expands the list), one avatar per conversation (the
/// selected one ringed in the ember accent), and an expand control at the foot.
class ConversationRail extends ConsumerWidget {
  const ConversationRail({super.key, required this.onExpand});

  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final controller = ref.read(chatControllerProvider.notifier);
    final selectedId = ref.watch(chatControllerProvider).selectedId;
    final convos = ref.watch(conversationListProvider);

    return SizedBox(
      width: 60,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Tooltip(
            message: 'New chat',
            child: IconButton.filled(
              onPressed: controller.newChat,
              icon: const Icon(Icons.add),
            ),
          ),
          const SizedBox(height: 4),
          Tooltip(
            message: 'Search conversations',
            child: IconButton(
              onPressed: onExpand,
              icon: const Icon(Icons.search),
            ),
          ),
          const Divider(indent: 14, endIndent: 14),
          Expanded(
            child: convos.maybeWhen(
              data: (list) => _avatars(controller, list, selectedId, scheme),
              orElse: () => const SizedBox.shrink(),
            ),
          ),
          Tooltip(
            message: 'Expand list',
            child: IconButton(
              onPressed: onExpand,
              icon: Icon(Icons.chevron_right, color: scheme.primary),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _avatars(
    ChatController controller,
    List<Conversation> list,
    int? selectedId,
    ColorScheme scheme,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: list.length,
      itemBuilder: (context, i) => _Avatar(
        conversation: list[i],
        selected: list[i].id != null && list[i].id == selectedId,
        scheme: scheme,
        onTap: () => controller.open(list[i]),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.conversation,
    required this.selected,
    required this.scheme,
    required this.onTap,
  });

  final Conversation conversation;
  final bool selected;
  final ColorScheme scheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final letter = conversation.title.trim().isEmpty
        ? '?'
        : conversation.title.trim()[0].toUpperCase();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Tooltip(
          message: conversation.title,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.surfaceContainerHighest,
                border: selected
                    ? Border.all(color: scheme.primary, width: 2)
                    : null,
              ),
              alignment: Alignment.center,
              child: conversation.isPinned
                  ? _pinned(letter)
                  : Text(letter, style: _letterStyle),
            ),
          ),
        ),
      ),
    );
  }

  Widget _pinned(String letter) => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Text(letter, style: _letterStyle),
          const Positioned(
            top: -8,
            right: -8,
            child: Text('📌', style: TextStyle(fontSize: 11)),
          ),
        ],
      );

  static const _letterStyle =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 14);
}
