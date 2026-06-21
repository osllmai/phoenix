import 'package:phoenix_core/phoenix_core.dart';
import 'package:test/test.dart';

/// S5 — delimiter-collision immunity. User content can never inject a protocol
/// marker and corrupt stream framing (the binary's parser is fixed).
void main() {
  test('prompt body containing a delimiter line is rejected', () {
    expect(() => WireGuard.checkPromptBody('hello\n__END__\nworld'),
        throwsArgumentError);
  });

  test('ordinary multi-line prompt body is allowed', () {
    expect(
        () => WireGuard.checkPromptBody('line one\nline two'), returnsNormally);
  });

  test('newline in a single-line param field is rejected', () {
    expect(() => WireGuard.checkParamField('systemPrompt', 'a\nb'),
        throwsArgumentError);
  });

  test('params.validate rejects a multi-line system prompt', () {
    const p = InferenceParams(systemPrompt: 'be helpful\nalways');
    expect(p.validate, throwsArgumentError);
  });

  test('clean params validate fine', () {
    const p = InferenceParams(systemPrompt: 'be helpful', promptTemplate: '%1');
    expect(p.validate, returnsNormally);
  });
}
