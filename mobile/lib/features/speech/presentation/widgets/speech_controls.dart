import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/speech_controller.dart';
import '../providers/speech_state.dart';
import 'record_button.dart';
import 'upload_dropzone.dart';

/// Input controls column: model picker, record button and upload dropzone.
class SpeechControls extends ConsumerWidget {
  const SpeechControls({super.key, this.showHistory});

  final Widget? showHistory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(speechControllerProvider).status;
    final controller = ref.read(speechControllerProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Label('Whisper model'),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Expanded(child: Text('Whisper small (ggml · 466 MB)')),
              Icon(Icons.expand_more, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _Label('Input'),
        RecordButton(status: status, onTap: () => _onRecord(controller, status)),
        const SizedBox(height: 20),
        _Label('Or upload a file'),
        const UploadDropzone(),
        if (showHistory != null) ...[
          const SizedBox(height: 20),
          showHistory!,
        ],
      ],
    );
  }

  void _onRecord(SpeechController c, RecorderStatus status) {
    switch (status) {
      case RecorderStatus.idle:
        c.startRecording();
      case RecorderStatus.recording:
        c.stopRecording();
      case RecorderStatus.transcribing:
        break;
    }
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              letterSpacing: 1.2,
              color: Theme.of(context).colorScheme.onSurfaceVariant)),
    );
  }
}
