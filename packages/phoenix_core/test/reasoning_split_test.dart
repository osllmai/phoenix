import 'package:phoenix_core/phoenix_core.dart';
import 'package:test/test.dart';

void main() {
  test('plain reply has no reasoning', () {
    final s = splitReasoning('Mercury, Venus, Mars');
    expect(s.hasReasoning, isFalse);
    expect(s.answer, 'Mercury, Venus, Mars');
  });

  test('closed block splits into reasoning and answer', () {
    final s = splitReasoning('<think>counting planets</think>Mercury, Venus, Mars');
    expect(s.reasoning, 'counting planets');
    expect(s.answer, 'Mercury, Venus, Mars');
  });

  test('unterminated block mid-stream is all reasoning', () {
    final s = splitReasoning('<think>still working');
    expect(s.reasoning, 'still working');
    expect(s.answer, isEmpty);
  });

  test('text before the block stays in the answer', () {
    final s = splitReasoning('Sure. <think>why not</think>Done.');
    expect(s.reasoning, 'why not');
    expect(s.answer, 'Sure. Done.');
  });

  test('multiple blocks concatenate', () {
    final s = splitReasoning('<think>one</think>A<think>two</think>B');
    expect(s.reasoning, 'onetwo');
    expect(s.answer, 'AB');
  });

  test('empty text stays empty', () {
    final s = splitReasoning('');
    expect(s.hasReasoning, isFalse);
    expect(s.answer, isEmpty);
  });
}
