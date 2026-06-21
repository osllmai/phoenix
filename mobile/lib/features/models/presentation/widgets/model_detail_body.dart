import 'package:flutter/material.dart';
import 'package:phoenix_core/phoenix_core.dart';

class ModelIdentityCard extends StatelessWidget {
  const ModelIdentityCard({super.key, required this.model});

  final AiModel model;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(model.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              model.isInstalled ? model.key! : 'No file set',
              style: TextStyle(
                fontFamily: 'monospace',
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModelLifecycle extends StatelessWidget {
  const ModelLifecycle({
    super.key,
    required this.model,
    required this.isLoading,
    required this.isActive,
    required this.error,
    required this.onLoad,
  });

  final AiModel model;
  final bool isLoading;
  final bool isActive;
  final String? error;
  final VoidCallback onLoad;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (isLoading) {
      return const Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Loading into the engine… other models can\'t load until this finishes.',
            ),
          ),
        ],
      );
    }
    if (isActive) {
      return Row(
        children: [
          Icon(Icons.check_circle, color: cs.primary),
          const SizedBox(width: 8),
          const Text('Active — loaded and serving chat.'),
        ],
      );
    }
    if (!model.isInstalled) {
      return _box(
        cs.errorContainer,
        cs.onErrorContainer,
        'This model has no file to load. Re-add it from disk.',
      );
    }
    if (error != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _box(cs.errorContainer, cs.onErrorContainer, error!),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onLoad,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry load'),
          ),
        ],
      );
    }
    return FilledButton.icon(
      onPressed: onLoad,
      icon: const Icon(Icons.play_arrow),
      label: const Text('Load model'),
    );
  }

  Widget _box(Color bg, Color fg, String msg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(msg, style: TextStyle(color: fg)),
    );
  }
}
