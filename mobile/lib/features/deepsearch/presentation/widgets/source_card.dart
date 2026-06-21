import 'package:flutter/material.dart';

import '../providers/deepsearch_state.dart';

class SourceCard extends StatelessWidget {
  const SourceCard({super.key, required this.source});

  final SearchSource source;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Rank(rank: source.rank, scheme: scheme),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(source.title, style: text.titleSmall),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        child: Text(source.domain,
                            style: text.bodySmall?.copyWith(color: scheme.primary)),
                      ),
                      if (source.isLocal) ...[
                        const SizedBox(width: 6),
                        _Badge(scheme: scheme),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  _Relevance(value: source.relevance, scheme: scheme),
                  const SizedBox(height: 8),
                  Text(source.snippet,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        child: Text(source.isLocal ? 'View in Docs' : 'Open'),
                      ),
                      OutlinedButton(onPressed: () {}, child: const Text('Cite')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Rank extends StatelessWidget {
  const _Rank({required this.rank, required this.scheme});

  final int rank;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text('[$rank]', style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text('LOCAL',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.onTertiaryContainer,
              )),
    );
  }
}

class _Relevance extends StatelessWidget {
  const _Relevance({required this.value, required this.scheme});

  final int value;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: value / 100, minHeight: 4),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text('$value% relevant',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  )),
        ),
      ],
    );
  }
}
