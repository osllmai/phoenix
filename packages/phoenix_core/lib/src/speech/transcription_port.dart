/// Engine-agnostic speech-to-text contract.
///
/// Callers (Flutter UI, HTTP gateway, CLI) depend ONLY on [TranscriptionPort],
/// never on a concrete transcriber. Today it is backed by [StubTranscriber]; a
/// future whisper.cpp engine drops in here without touching any caller — the
/// same seam [InferencePort] gives the LLM.
library;

/// Lifecycle state of a transcriber.
enum TranscriberState { idle, loadingModel, transcribing, error }

/// One time-stamped chunk of recognized speech.
class TranscriptionSegment {
  const TranscriptionSegment({
    required this.start,
    required this.end,
    required this.text,
  });

  /// Segment start offset, in seconds from the audio origin.
  final double start;

  /// Segment end offset, in seconds from the audio origin.
  final double end;

  final String text;
}

/// The result of transcribing one audio file.
class Transcription {
  const Transcription({
    required this.text,
    this.segments = const [],
    this.language = 'auto',
  });

  /// Full recognized text (all segments joined).
  final String text;

  /// Optional per-segment breakdown with timing.
  final List<TranscriptionSegment> segments;

  /// Detected or requested language code (e.g. `en`, or `auto`).
  final String language;
}

/// Engine-agnostic speech-to-text interface.
abstract interface class TranscriptionPort {
  /// Current lifecycle state.
  TranscriberState get state;

  /// Transcribes the audio at [audioPath]. [language] is a hint (`auto` lets the
  /// engine detect). Throws [ArgumentError] if [audioPath] is empty.
  Future<Transcription> transcribe(String audioPath, {String language});

  /// Releases the underlying model/process resources.
  Future<void> dispose();
}
