import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/deepsearch_controller.dart';

class FirstRunView extends ConsumerWidget {
  const FirstRunView({super.key});

  static const _examples = [
    'Latest techniques to reduce LLM inference latency',
    'KV-cache compression methods in 2024',
    'RAG vs long-context trade-offs',
    'How does speculative decoding work?',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final n = ref.read(deepSearchControllerProvider.notifier);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🔭', style: TextStyle(fontSize: 46)),
                      const SizedBox(height: 12),
                      Text('Enter your first research question',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        'Phoenix searches the web and your local documents, '
                        'reads and ranks the results, then synthesizes a cited '
                        'answer — synthesis runs entirely on your device.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          for (final e in _examples)
                            ActionChip(
                                label: Text(e), onPressed: () => n.run(e)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
