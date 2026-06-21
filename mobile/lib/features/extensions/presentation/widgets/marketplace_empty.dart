import 'package:flutter/material.dart';

class MarketplaceEmpty extends StatelessWidget {
  const MarketplaceEmpty({super.key, required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔍', style: TextStyle(fontSize: 44)),
                  const SizedBox(height: 12),
                  Text('No extensions found',
                      style: text.titleMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(
                    'Nothing matches your search. Try a different term, '
                    'or browse all categories.',
                    style: text.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: onClear,
                    child: const Text('Clear filters'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
