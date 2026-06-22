import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_core/phoenix_core.dart';

import '../../../../core/ai/cloud_engine.dart';
import '../../../../core/ai/engine_provider.dart';
import 'models_controller.dart';

/// App-wide compute mode (local on-device vs cloud gateway). Defaults to local.
class ComputeModeNotifier extends Notifier<ComputeMode> {
  @override
  ComputeMode build() => ComputeMode.local;
  void set(ComputeMode mode) => state = mode;
}

final computeModeProvider =
    NotifierProvider<ComputeModeNotifier, ComputeMode>(ComputeModeNotifier.new);

/// The selected cloud model (null until one is picked).
class CloudModelNotifier extends Notifier<CloudModel?> {
  @override
  CloudModel? build() => null;
  void set(CloudModel? model) => state = model;
}

final cloudModelProvider =
    NotifierProvider<CloudModelNotifier, CloudModel?>(CloudModelNotifier.new);

/// The single globally-selected model — derived from the mode plus the active
/// local model / selected cloud model. Null when nothing is selected.
final selectedModelProvider = Provider<SelectedModel?>((ref) {
  if (ref.watch(computeModeProvider) == ComputeMode.cloud) {
    final cloud = ref.watch(cloudModelProvider);
    return cloud == null ? null : CloudSelection(cloud);
  }
  final local = ref.watch(activeModelProvider);
  return local == null ? null : LocalSelection(local);
});

/// The engine the selected model routes to: the local subprocess engine or the
/// cloud stub. Inference callers watch this instead of a fixed engine.
final activeEngineProvider = Provider<InferencePort>((ref) {
  final selection = ref.watch(selectedModelProvider);
  return selection?.mode == ComputeMode.cloud
      ? ref.watch(cloudEngineProvider)
      : ref.watch(inferenceEngineProvider);
});
