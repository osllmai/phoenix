import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class AnswerPane extends StatelessWidget {
  const AnswerPane({super.key, required this.answer, this.sourceCount = 0});

  final String answer;
  final int sourceCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SYNTHESIZED ANSWER',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  letterSpacing: 1.2,
                )),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GptMarkdown(answer),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                _Meta(scheme: scheme, sourceCount: sourceCount),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.scheme, required this.sourceCount});

  final ColorScheme scheme;
  final int sourceCount;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        );
    return Wrap(
      spacing: 16,
      runSpacing: 4,
      children: [
        Text('$sourceCount source${sourceCount == 1 ? '' : 's'}', style: style),
        Text('On-device synthesis', style: style),
      ],
    );
  }
}
