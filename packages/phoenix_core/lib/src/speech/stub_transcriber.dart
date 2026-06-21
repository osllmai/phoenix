import 'transcription_port.dart';

/// Deterministic placeholder transcriber so the speech UI works today.
///
// SEAM: the real on-device whisper.cpp/ggml engine implements [TranscriptionPort]
// here and replaces this stub — deferred, like Docling/embeddings.
class StubTranscriber implements TranscriptionPort {
  TranscriberState _state = TranscriberState.idle;

  @override
  TranscriberState get state => _state;

  @override
  Future<Transcription> transcribe(
    String audioPath, {
    String language = 'auto',
  }) async {
    if (audioPath.isEmpty) {
      throw ArgumentError.value(audioPath, 'audioPath', 'must not be empty');
    }
    _state = TranscriberState.transcribing;
    const segments = [
      TranscriptionSegment(
        start: 0.0,
        end: 4.0,
        text: 'Welcome to Phoenix — your on-device AI studio.',
      ),
      TranscriptionSegment(
        start: 4.0,
        end: 11.0,
        text: 'Speech runs locally; nothing leaves your machine.',
      ),
      TranscriptionSegment(
        start: 11.0,
        end: 18.0,
        text: 'A real whisper.cpp engine will replace this stub.',
      ),
    ];
    _state = TranscriberState.idle;
    return Transcription(
      text: segments.map((s) => s.text).join(' '),
      segments: segments,
      language: language == 'auto' ? 'en' : language,
    );
  }

  @override
  Future<void> dispose() async {
    _state = TranscriberState.idle;
  }
}
