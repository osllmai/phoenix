/// Typed engine failures surfaced to callers (S3/S6), replacing the legacy
/// silent-finish / generic-StateError behavior.
library;

/// What went wrong in the engine.
enum EngineFailure {
  /// The subprocess exited or its pipe broke mid-operation.
  crash,

  /// The engine reported a runtime error (stderr / non-zero exit / no ack).
  error,

  /// Host-side protocol or contract violation (bad framing/state).
  protocol,
}

/// A typed engine error. Carries the [kind], a human [message], and — when the
/// process died — its [exitCode] and the tail of stderr for diagnosis.
class EngineException implements Exception {
  EngineException(this.kind, this.message, {this.exitCode, this.stderrTail});

  final EngineFailure kind;
  final String message;
  final int? exitCode;
  final String? stderrTail;

  @override
  String toString() {
    final code = exitCode == null ? '' : ' (exit $exitCode)';
    final err =
        (stderrTail == null || stderrTail!.isEmpty) ? '' : '\n$stderrTail';
    return 'EngineException[${kind.name}]$code: $message$err';
  }
}
