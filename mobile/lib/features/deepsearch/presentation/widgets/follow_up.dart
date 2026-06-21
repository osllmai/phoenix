import 'package:flutter/material.dart';

class FollowUp extends StatelessWidget {
  const FollowUp({super.key});

  static const _suggestions = [
    'How much memory does 4-bit KV-cache save?',
    'Which draft model size is optimal?',
    'Compare speculative decoding vs Medusa',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Ask a follow-up — keeps this research context…',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(onPressed: () {}, child: const Text('Ask')),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final s in _suggestions)
              ActionChip(label: Text(s), onPressed: () {}),
          ],
        ),
      ],
    );
  }
}
