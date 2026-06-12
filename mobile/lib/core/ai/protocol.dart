/// Wire markers for the `applocal_provider` stdin/stdout text protocol.
///
/// These are the exact tokens used by the legacy Qt `OfflineProvider`
/// (`core/provider/offlineprovider.cpp`). Keeping them in one place means the
/// Dart engine and any mock speak a single source of truth.
library;

class EngineProtocol {
  EngineProtocol._();

  /// Engine → host: emitted once the model finished loading.
  static const String loadingFinished = '__LoadingModel__Finished__';

  /// Host → engine: begins the prompt text (sent after the params block).
  static const String promptBegin = '__PROMPT__';

  /// Host → engine: terminates the prompt text.
  static const String promptEnd = '__END__';

  /// Engine → host: marks the end of a streamed response.
  static const String done = '__DONE_PROMPTPROCESS__';

  /// Host → engine: aborts the in-flight generation.
  static const String stop = '__STOP__';

  /// Host → engine: opens the parameter settings block.
  static const String paramsBegin = '__PARAMS_SETTINGS__';

  /// Host → engine: closes the parameter settings block.
  static const String paramsEnd = '__END_PARAMS_SETTINGS__';
}
