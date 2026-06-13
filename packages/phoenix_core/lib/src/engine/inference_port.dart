/// Engine-agnostic inference contract.
///
/// The whole app (UI → services) depends ONLY on this interface, never on a
/// concrete engine. Today it is backed by [SubprocessEngine] (the existing
/// `applocal_provider` llama.cpp binary); a future `FfiEngine` for mobile can
/// drop in without touching any caller.
library;

import 'wire_guard.dart';

/// Generation parameters sent to the engine per prompt.
///
/// Field names/order mirror the `__PARAMS_SETTINGS__` block emitted by the
/// legacy Qt `OfflineProvider` so the same engine binary is driven unchanged.
class InferenceParams {
  const InferenceParams({
    this.stream = true,
    this.promptTemplate = '',
    this.systemPrompt = '',
    this.maxTokens = 512,
    this.topK = 40,
    this.topP = 0.95,
    this.minP = 0.05,
    this.temperature = 0.7,
    this.promptBatchSize = 128,
    this.repeatPenalty = 1.1,
    this.repeatPenaltyTokens = 64,
    this.contextLength = 4096,
    this.numberOfGpuLayers = 0,
  });

  final bool stream;
  final String promptTemplate;
  final String systemPrompt;
  final int maxTokens;
  final int topK;
  final double topP;
  final double minP;
  final double temperature;
  final int promptBatchSize;
  final double repeatPenalty;
  final int repeatPenaltyTokens;
  final int contextLength;
  final int numberOfGpuLayers;

  /// Rejects single-line fields that would corrupt the params block (S5).
  void validate() {
    WireGuard.checkParamField('promptTemplate', promptTemplate);
    WireGuard.checkParamField('systemPrompt', systemPrompt);
  }

  /// Renders the exact `__PARAMS_SETTINGS__ … __END_PARAMS_SETTINGS__` block the
  /// engine expects (see `core/provider/offlineprovider.cpp`).
  String toParamBlock() {
    final b = StringBuffer()
      ..writeln('__PARAMS_SETTINGS__')
      ..writeln('stream=${stream ? 'true' : 'false'}')
      ..writeln('prompt_template=$promptTemplate')
      ..writeln('system_prompt=$systemPrompt')
      ..writeln('n_predict=$maxTokens')
      ..writeln('top_k=$topK')
      ..writeln('top_p=$topP')
      ..writeln('min_p=$minP')
      ..writeln('temp=$temperature')
      ..writeln('n_batch=$promptBatchSize')
      ..writeln('repeat_penalty=$repeatPenalty')
      ..writeln('repeat_last_n=$repeatPenaltyTokens')
      ..writeln('ctx_size=$contextLength')
      ..writeln('n_gpu_layers=$numberOfGpuLayers')
      ..writeln('__END_PARAMS_SETTINGS__');
    return b.toString();
  }
}

/// Lifecycle state of an engine, mirroring the legacy `ProviderState`.
enum EngineState { idle, loadingModel, ready, generating, stopped, error }

/// Engine-agnostic inference interface.
abstract interface class InferencePort {
  /// Current lifecycle state.
  EngineState get state;

  /// Loads a model by file path (e.g. a `.gguf`). Completes when the engine
  /// reports the model is ready to accept prompts.
  Future<void> loadModel(String modelPath);

  /// Streams generated text tokens for [prompt]. The stream closes when the
  /// engine signals end-of-response. Throws [StateError] if no model is loaded
  /// or a generation is already in flight; throws [ArgumentError] if [prompt] or
  /// [params] would collide with the wire protocol. On a crash/error the stream
  /// emits an `EngineException` then closes.
  Stream<String> prompt(String prompt, {InferenceParams params});

  /// Requests the engine stop the in-flight generation. No-op when idle. The
  /// token stream closes once the engine acknowledges (its `__DONE__`).
  Future<void> stop();

  /// Tears down the engine and releases the underlying process/resources.
  Future<void> dispose();
}
