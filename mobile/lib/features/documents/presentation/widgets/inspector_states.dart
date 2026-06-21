import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

import '../providers/document.dart';
import 'doc_chips.dart';
import 'library_states.dart';

class InspectorMarkdownView extends StatelessWidget {
  const InspectorMarkdownView({super.key, required this.doc});

  final PhoenixDocument doc;

  @override
  Widget build(BuildContext context) {
    if (doc.markdown.isEmpty) {
      return InspectorPending(status: doc.status);
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: GptMarkdown(doc.markdown),
    );
  }
}

class InspectorPending extends StatelessWidget {
  const InspectorPending({super.key, required this.status});

  final DocStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CenteredState(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hourglass_empty, size: 40, color: scheme.outline),
          const SizedBox(height: 12),
          Text('${docStatusLabel(status)} on the backend…',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: scheme.outline)),
        ],
      ),
    );
  }
}

class InspectorNoSelection extends StatelessWidget {
  const InspectorNoSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CenteredState(
      child: Text('Select a document to preview',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: scheme.outline)),
    );
  }
}

class InspectorLoadError extends StatelessWidget {
  const InspectorLoadError({super.key, required this.message, this.onBack});

  final String message;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (onBack != null)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        Expanded(
          child: CenteredState(
            child: Text('Could not load document\n$message',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: scheme.error)),
          ),
        ),
      ],
    );
  }
}
