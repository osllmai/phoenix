import 'ai_model.dart';

/// Where inference for the selected model runs.
enum ComputeMode { local, cloud }

/// A cloud-hosted model reachable through the IndoxHub gateway or a provider.
class CloudModel {
  const CloudModel({
    required this.id,
    required this.name,
    required this.provider,
  });

  final String id;
  final String name;
  final String provider;
}

/// The app's globally-selected chat model: an installed [LocalSelection] or a
/// [CloudSelection]. Inference routes on [mode].
sealed class SelectedModel {
  const SelectedModel();

  ComputeMode get mode;
  String get name;
}

class LocalSelection extends SelectedModel {
  const LocalSelection(this.model);

  final AiModel model;

  @override
  ComputeMode get mode => ComputeMode.local;

  @override
  String get name => model.name;
}

class CloudSelection extends SelectedModel {
  const CloudSelection(this.model);

  final CloudModel model;

  @override
  ComputeMode get mode => ComputeMode.cloud;

  @override
  String get name => model.name;
}
