import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_core/phoenix_core.dart';

/// Placeholder cloud engine used when [ComputeMode.cloud] is selected. The real
/// implementation will call the IndoxHub gateway; until that client lands this
/// streams a notice so the surface stays functional.
class CloudEngineStub implements InferencePort {
  @override
  EngineState get state => EngineState.idle;

  @override
  Future<void> loadModel(String modelPath) async {}

  @override
  Stream<String> prompt(
    String prompt, {
    InferenceParams params = const InferenceParams(),
  }) async* {
    yield 'Cloud inference via the IndoxHub gateway is not wired up yet — '
        'switch to a local model to chat now.';
  }

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}
}

final cloudEngineProvider =
    Provider<InferencePort>((ref) => CloudEngineStub());
