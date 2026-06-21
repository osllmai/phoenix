import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_core/phoenix_core.dart';

import '../../../models/presentation/providers/model_providers.dart';

/// The conversation header: a model picker (active model + quick switch) and a
/// conversation-parameters button. A menu button leads on phone.
class ChatHeader extends ConsumerWidget {
  const ChatHeader({super.key, this.onMenu});

  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final active = ref.watch(activeModelProvider);
    final models = ref.watch(modelsControllerProvider).asData?.value ?? const [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          if (onMenu != null)
            IconButton(onPressed: onMenu, icon: const Icon(Icons.menu)),
          _ModelPicker(active: active, models: models, ref: ref),
          const Spacer(),
          IconButton(
            tooltip: 'Conversation parameters',
            onPressed: () => _showParams(context),
            icon: Icon(Icons.tune, color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  void _showParams(BuildContext context) => showDialog<void>(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Conversation parameters'),
          content: Text('Temperature, system prompt and context settings are '
              'coming soon.'),
        ),
      );
}

class _ModelPicker extends StatelessWidget {
  const _ModelPicker({required this.active, required this.models, required this.ref});

  final AiModel? active;
  final List<AiModel> models;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final loaded = active != null;
    return PopupMenuButton<AiModel>(
      tooltip: 'Switch model',
      onSelected: (m) => ref.read(modelsControllerProvider.notifier).select(m),
      itemBuilder: (_) => [
        for (final m in models)
          PopupMenuItem(value: m, child: Text(m.name)),
        if (models.isEmpty)
          const PopupMenuItem(enabled: false, child: Text('No models installed')),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: loaded ? const Color(0xFF6FCF97) : scheme.outline,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(active?.name ?? 'Select a model',
              style: theme.textTheme.titleMedium),
          Icon(Icons.arrow_drop_down, color: scheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
