import 'package:phoenix_core/phoenix_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'speech_state.dart';
import 'transcription_provider.dart';

part 'speech_controller.g.dart';

/// Drives the speech surface: record → transcribe → idle, surfacing the result
/// and appending it to history. Calls the core [TranscriptionPort]; mirrors the
/// `@riverpod` Notifier pattern in `chat_controller.dart`.
@riverpod
class SpeechController extends _$SpeechController {
  late final TranscriptionPort _port;

  @override
  SpeechState build() {
    _port = ref.watch(transcriptionPortProvider);
    return const SpeechState();
  }

  void startRecording() {
    if (state.status != RecorderStatus.idle) return;
    state = state.copyWith(
      status: RecorderStatus.recording,
      elapsedSeconds: 0,
      transcript: const [],
    );
  }

  /// Stops the (mocked) recording and transcribes it via the core port.
  // SEAM: real mic capture writes a temp file whose path replaces [_capturePath].
  Future<void> stopRecording() async {
    if (state.status != RecorderStatus.recording) return;
    await transcribe(_capturePath);
  }

  Future<void> transcribe(String audioPath, {String language = 'auto'}) async {
    state = state.copyWith(status: RecorderStatus.transcribing, progress: 0.5);
    final result = await _port.transcribe(audioPath, language: language);
    state = state.copyWith(
      status: RecorderStatus.idle,
      progress: 0,
      transcript: _toSegments(result),
      history: [_toHistory(result, audioPath), ...state.history],
    );
  }

  void cancel() {
    state = state.copyWith(status: RecorderStatus.idle, progress: 0);
  }

  static const _capturePath = 'mic://capture.wav';

  List<TranscriptSegment> _toSegments(Transcription t) => [
        for (final s in t.segments)
          TranscriptSegment(
            time: '${_clock(s.start)} → ${_clock(s.end)}',
            speaker: 'Speaker 1',
            text: s.text,
          ),
      ];

  PastTranscription _toHistory(Transcription t, String path) {
    final end = t.segments.isEmpty ? 0.0 : t.segments.last.end;
    return PastTranscription(
      title: path.split('/').last,
      duration: _clock(end),
      language: t.language,
      date: 'Just now',
    );
  }

  String _clock(double seconds) {
    final s = seconds.round();
    final mm = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }
}
