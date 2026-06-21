import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/speech_controller.dart';
import 'transcript_view.dart';

/// The transcript output pane: a toolbar over the transcript area.
class TranscriptPane extends ConsumerWidget {
  const TranscriptPane({super.key, this.onMenu});

  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(speechControllerProvider);
    final hasTranscript = state.transcript.isNotEmpty;

    return LayoutBuilder(
      builder: (context, constraints) => Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              if (onMenu != null)
                IconButton(onPressed: onMenu, icon: const Icon(Icons.menu)),
              Expanded(
                child: Text('Transcript',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              IconButton(
                onPressed: hasTranscript ? () {} : null,
                icon: const Icon(Icons.copy_outlined),
                tooltip: 'Copy',
              ),
              IconButton(
                onPressed: hasTranscript ? () {} : null,
                icon: const Icon(Icons.download_outlined),
                tooltip: 'Export',
              ),
              if (constraints.maxWidth >= 360)
                FilledButton.icon(
                  onPressed: hasTranscript ? () {} : null,
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: const Text('Send to Chat'),
                )
              else
                IconButton.filled(
                  onPressed: hasTranscript ? () {} : null,
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  tooltip: 'Send to Chat',
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: TranscriptView(state: state)),
      ],
      ),
    );
  }
}
