import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/document.dart';
import '../providers/documents_providers.dart';
import 'inspector_states.dart';

class DocumentInspector extends ConsumerWidget {
  const DocumentInspector({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedDocumentProvider);
    return selected.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => InspectorLoadError(message: '$e', onBack: onBack),
      data: (doc) {
        if (doc == null) return const InspectorNoSelection();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(doc: doc, onBack: onBack),
            const Divider(height: 1),
            Expanded(child: InspectorMarkdownView(doc: doc)),
          ],
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.doc, this.onBack});

  final PhoenixDocument doc;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (onBack != null)
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                ),
              Expanded(
                child: Text(doc.title, style: text.titleLarge),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${doc.badge} · ${doc.meta}',
            style: text.bodySmall?.copyWith(color: scheme.outline),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _Action(icon: Icons.download_outlined, label: 'Export'),
              _Action(icon: Icons.translate, label: 'Translate'),
              _Action(icon: Icons.chat_bubble_outline, label: 'Chat'),
              _Action(icon: Icons.refresh, label: 'Re-convert'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label),
    );
  }
}
