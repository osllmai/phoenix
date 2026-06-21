import 'package:flutter/material.dart';

class CenteredState extends StatelessWidget {
  const CenteredState({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class LibraryFirstRun extends StatelessWidget {
  const LibraryFirstRun({super.key, this.onAdd});

  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return CenteredState(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.folder_open_outlined, size: 48, color: scheme.primary),
          const SizedBox(height: 12),
          Text('No documents yet', style: text.titleMedium),
          const SizedBox(height: 6),
          Text(
            'Add a PDF or office file — Phoenix converts it to clean '
            'markdown and indexes it on-device.',
            textAlign: TextAlign.center,
            style: text.bodySmall?.copyWith(color: scheme.outline),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onAdd ?? () {},
            icon: const Icon(Icons.add),
            label: const Text('Add document'),
          ),
        ],
      ),
    );
  }
}

class LibraryFilteredEmpty extends StatelessWidget {
  const LibraryFilteredEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return CenteredState(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: scheme.outline),
          const SizedBox(height: 12),
          Text('No documents match', style: text.titleMedium),
          const SizedBox(height: 4),
          Text('Clear the filter or add a new file.',
              textAlign: TextAlign.center,
              style: text.bodySmall?.copyWith(color: scheme.outline)),
        ],
      ),
    );
  }
}

class LibraryError extends StatelessWidget {
  const LibraryError({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return CenteredState(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off, size: 48, color: scheme.error),
          const SizedBox(height: 12),
          Text('Could not load documents', style: text.titleMedium),
          const SizedBox(height: 4),
          Text(message,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: text.bodySmall?.copyWith(color: scheme.outline)),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
