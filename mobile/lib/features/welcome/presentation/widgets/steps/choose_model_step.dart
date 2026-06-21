import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/welcome_content.dart';
import '../../providers/welcome_controller.dart';
import '../../providers/welcome_models.dart';
import '../parts/download_panel.dart';
import '../parts/model_card.dart';

/// Step 2 content — the model picker (idle), or the stubbed download progress /
/// error panel once a download is in flight.
class ChooseModelStep extends ConsumerWidget {
  const ChooseModelStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(welcomeControllerProvider);
    final controller = ref.read(welcomeControllerProvider.notifier);

    if (state.isDownloading) {
      return DownloadProgress(modelName: 'your model', progress: state.progress);
    }
    if (state.hasError) return const DownloadError();

    final models = ref.watch(onboardingModelsProvider);
    return models.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const DownloadError(),
      data: (list) => _picker(context, ref, state.selectedModelId, controller, list),
    );
  }

  Widget _picker(BuildContext context, WidgetRef ref, String selectedId,
      WelcomeController controller, List<OnboardingModel> list) {
    final effectiveId = list.any((m) => m.id == selectedId)
        ? selectedId
        : (list.isEmpty ? '' : list.first.id);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final m in list) ...[
          ModelCard(
            model: m,
            selected: effectiveId == m.id,
            onTap: () => controller.selectModel(m.id),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 4),
        Row(
          children: [
            for (final s in modelSources) ...[
              Expanded(child: _source(theme, s.$1, s.$2)),
              if (s != modelSources.last) const SizedBox(width: 12),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Text('The model installs in the background — enter Phoenix now and keep '
            'working while it finishes.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: scheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _source(ThemeData theme, IconData icon, String label) {
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: scheme.onSurfaceVariant),
          const SizedBox(height: 6),
          Text(label,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
