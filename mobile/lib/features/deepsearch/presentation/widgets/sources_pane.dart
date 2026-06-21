import 'package:flutter/material.dart';

import '../providers/deepsearch_state.dart';
import 'source_card.dart';

class SourcesPane extends StatelessWidget {
  const SourcesPane({super.key, required this.sources});

  final List<SearchSource> sources;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SOURCES (${sources.length})',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  letterSpacing: 1.2,
                )),
        const SizedBox(height: 8),
        for (final s in sources) SourceCard(source: s),
      ],
    );
  }
}
