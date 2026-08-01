import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/models/presentation/providers/model_providers.dart';
import '../features/settings/presentation/providers/settings_controller.dart';

/// Once preferences load, selects the model named by the default-model setting
/// (if installed and nothing is active yet) so chat opens on the user's choice.
final defaultModelBootstrapProvider = FutureProvider<void>((ref) async {
  final settings = await ref.watch(settingsControllerProvider.future);
  await ref
      .read(modelsControllerProvider.notifier)
      .applyDefaultModel(settings.defaultModel);
});
