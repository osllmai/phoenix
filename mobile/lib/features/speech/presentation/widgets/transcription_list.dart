import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/past_transcriptions_provider.dart';

/// List of past transcriptions. A side pane (tablet/desktop) or a card section.
class TranscriptionList extends ConsumerWidget {
  const TranscriptionList({super.key, this.dense = false});

  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(pastTranscriptionsProvider);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text('History',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.onSurfaceVariant)),
        ),
        Flexible(
          fit: dense ? FlexFit.loose : FlexFit.tight,
          child: items.isEmpty
              ? _HistoryEmpty(scheme: scheme)
              : ListView.builder(
                  shrinkWrap: dense,
                  physics: dense ? const NeverScrollableScrollPhysics() : null,
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final t = items[i];
                    return ListTile(
                      leading: const Icon(Icons.graphic_eq),
                      title: Text(t.title,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('${t.duration} · ${t.language}'),
                      trailing: Text(t.date,
                          style: Theme.of(context).textTheme.labelSmall),
                      onTap: () {},
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _HistoryEmpty extends StatelessWidget {
  const _HistoryEmpty({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.history, color: scheme.onSurfaceVariant),
          const SizedBox(height: 8),
          Text('No past transcriptions',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text('Record to start — your transcripts appear here.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
