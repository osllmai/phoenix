import 'package:phoenix_core/phoenix_core.dart';
import 'package:test/test.dart';

void main() {
  group('StubTranscriber', () {
    test('returns a deterministic transcription with segments', () async {
      final t = StubTranscriber();
      final a = await t.transcribe('/tmp/clip.wav');
      final b = await t.transcribe('/tmp/clip.wav');

      expect(a.text, isNotEmpty);
      expect(a.text, b.text);
      expect(a.segments, isNotEmpty);
      expect(a.text, contains(a.segments.first.text));
    });

    test('joins segment text into the full transcript', () async {
      final t = StubTranscriber();
      final r = await t.transcribe('/tmp/clip.wav');
      expect(r.text, r.segments.map((s) => s.text).join(' '));
    });

    test('defaults auto language to a concrete code', () async {
      final t = StubTranscriber();
      final r = await t.transcribe('/tmp/clip.wav');
      expect(r.language, 'en');
    });

    test('honours an explicit language hint', () async {
      final t = StubTranscriber();
      final r = await t.transcribe('/tmp/clip.wav', language: 'fr');
      expect(r.language, 'fr');
    });

    test('rejects an empty audio path', () {
      final t = StubTranscriber();
      expect(() => t.transcribe(''), throwsArgumentError);
    });

    test('returns to idle after transcribing and disposing', () async {
      final t = StubTranscriber();
      expect(t.state, TranscriberState.idle);
      await t.transcribe('/tmp/clip.wav');
      expect(t.state, TranscriberState.idle);
      await t.dispose();
      expect(t.state, TranscriberState.idle);
    });
  });

  group('Transcription type', () {
    test('segments carry monotonic timing', () {
      const seg = TranscriptionSegment(start: 1.0, end: 2.5, text: 'hi');
      expect(seg.end, greaterThan(seg.start));
      expect(seg.text, 'hi');
    });

    test('defaults to empty segments and auto language', () {
      const tr = Transcription(text: 'hello');
      expect(tr.segments, isEmpty);
      expect(tr.language, 'auto');
    });
  });
}
