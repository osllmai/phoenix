import 'package:freezed_annotation/freezed_annotation.dart';

part 'speech_state.freezed.dart';

enum RecorderStatus { idle, recording, transcribing }

@freezed
abstract class TranscriptSegment with _$TranscriptSegment {
  const factory TranscriptSegment({
    required String time,
    required String speaker,
    required String text,
  }) = _TranscriptSegment;
}

@freezed
abstract class PastTranscription with _$PastTranscription {
  const factory PastTranscription({
    required String title,
    required String duration,
    required String language,
    required String date,
  }) = _PastTranscription;
}

@freezed
abstract class SpeechState with _$SpeechState {
  const factory SpeechState({
    @Default(RecorderStatus.idle) RecorderStatus status,
    @Default(0) int elapsedSeconds,
    @Default(0) double progress,
    @Default(<TranscriptSegment>[]) List<TranscriptSegment> transcript,
    @Default(<PastTranscription>[]) List<PastTranscription> history,
  }) = _SpeechState;
}
