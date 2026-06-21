import 'package:flutter/material.dart';

import '../providers/speech_state.dart';

/// The transcript area: empty / transcribing / segment list depending on state.
class TranscriptView extends StatelessWidget {
  const TranscriptView({super.key, required this.state});

  final SpeechState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == RecorderStatus.transcribing) {
      return _Transcribing(progress: state.progress);
    }
    if (state.transcript.isEmpty) return const SpeechEmptyState();
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.transcript.length,
      separatorBuilder: (_, _) => const Divider(height: 24),
      itemBuilder: (context, i) => _Segment(segment: state.transcript[i]),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.segment});

  final TranscriptSegment segment;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(segment.time,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: scheme.onSurfaceVariant)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(segment.speaker,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: scheme.onPrimaryContainer)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SelectableText(segment.text),
      ],
    );
  }
}

class SpeechEmptyState extends StatelessWidget {
  const SpeechEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _CenteredScroll(
      children: [
        Icon(Icons.mic_none, size: 44, color: scheme.onSurfaceVariant),
        const SizedBox(height: 12),
        Text('No transcriptions yet',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          'Record from your mic or choose an audio file to transcribe '
          'on-device with Whisper.',
          textAlign: TextAlign.center,
          style: TextStyle(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _Transcribing extends StatelessWidget {
  const _Transcribing({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _CenteredScroll(
      children: [
        SizedBox(
          width: 220,
          child: LinearProgressIndicator(value: progress),
        ),
        const SizedBox(height: 16),
        Text('Transcribing… ${(progress * 100).round()}%',
            style: TextStyle(color: scheme.onSurfaceVariant)),
      ],
    );
  }
}

class _CenteredScroll extends StatelessWidget {
  const _CenteredScroll({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
