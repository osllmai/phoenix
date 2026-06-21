import 'protocol.dart';

/// Validates host→engine content against the line-based protocol so user text
/// can never inject a control marker and corrupt stream framing (S5).
///
/// The engine binary's parser is fixed (we keep llama.cpp unchanged), so we
/// reject offending content rather than re-encode the wire.
class WireGuard {
  WireGuard._();

  /// Throws [ArgumentError] if any line of the prompt [body] is exactly a
  /// protocol delimiter. Newlines within the body are fine — the engine reads
  /// lines until `__END__`.
  static void checkPromptBody(String body) {
    for (final line in body.split('\n')) {
      if (EngineProtocol.isDelimiter(line)) {
        throw ArgumentError.value(
            line, 'prompt', 'contains a reserved protocol delimiter');
      }
    }
  }

  /// Throws [ArgumentError] if a single-line param [value] (e.g. systemPrompt,
  /// promptTemplate) contains a newline or a delimiter — either breaks the
  /// `key=value` params block.
  static void checkParamField(String name, String value) {
    if (value.contains('\n') || value.contains('\r')) {
      throw ArgumentError.value(value, name, 'must be single-line');
    }
    if (EngineProtocol.isDelimiter(value)) {
      throw ArgumentError.value(
          value, name, 'is a reserved protocol delimiter');
    }
  }
}
