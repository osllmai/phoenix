import 'package:flutter/material.dart';

import '../providers/speech_state.dart';

/// The big record control reflecting idle / recording / transcribing state.
class RecordButton extends StatelessWidget {
  const RecordButton({
    super.key,
    required this.status,
    required this.onTap,
  });

  final RecorderStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final busy = status != RecorderStatus.idle;
    final accent = busy ? scheme.error : scheme.primary;

    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.primaryContainer,
                  border: Border.all(color: accent, width: 2),
                ),
                child: Icon(_icon, color: accent, size: 28),
              ),
              const SizedBox(height: 12),
              Text(_label, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                _sub,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: busy ? accent : scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData get _icon => switch (status) {
        RecorderStatus.idle => Icons.mic_none,
        RecorderStatus.recording => Icons.stop,
        RecorderStatus.transcribing => Icons.graphic_eq,
      };

  String get _label => switch (status) {
        RecorderStatus.idle => 'Record',
        RecorderStatus.recording => 'Recording…',
        RecorderStatus.transcribing => 'Transcribing…',
      };

  String get _sub => switch (status) {
        RecorderStatus.idle => 'Tap to capture from your mic',
        RecorderStatus.recording => 'Tap to stop and transcribe',
        RecorderStatus.transcribing => 'Whisper small · on-device',
      };
}
