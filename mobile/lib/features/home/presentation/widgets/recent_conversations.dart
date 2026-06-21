import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:phoenix_core/phoenix_core.dart';

import '../../../chat/presentation/providers/conversation_list_provider.dart';
import 'dashboard_card.dart';

const _maxRecent = 4;

class RecentConversations extends ConsumerWidget {
  const RecentConversations({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final convos = ref.watch(conversationListProvider);
    return DashboardCard(
      title: 'Recent conversations',
      action: convos.maybeWhen(
        data: (list) => TextButton(
          onPressed: () {},
          child: Text('View all (${list.length})'),
        ),
        orElse: () => null,
      ),
      child: convos.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => const _Empty(label: 'Could not load conversations'),
        data: (list) {
          if (list.isEmpty) return const _Empty(label: 'No conversations yet');
          final recent = list.take(_maxRecent).toList();
          return Column(
            children: [for (final c in recent) _ConvRow(conversation: c)],
          );
        },
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}

class _ConvRow extends StatelessWidget {
  const _ConvRow({required this.conversation});

  final Conversation conversation;

  String get _icon => conversation.icon.isNotEmpty ? conversation.icon : '💬';

  String _time() {
    final d = conversation.date;
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Text(_icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (conversation.description.isNotEmpty)
                    Text(
                      conversation.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _time(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 18, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
