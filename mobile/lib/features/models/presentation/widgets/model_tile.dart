import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_core/phoenix_core.dart';

import '../providers/model_providers.dart';
import 'model_tile_actions.dart';

/// One catalog row: name · path · favorite · load/active · delete. Tap opens
/// the detail screen. Load is disabled while any model is loading (guard) or
/// when the model has no file.
class ModelTile extends ConsumerWidget {
  const ModelTile({super.key, required this.model, required this.onOpen});

  final AiModel model;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(modelsControllerProvider.notifier);
    final isActive = ref.watch(activeModelProvider)?.id == model.id;
    final loadingId = ref.watch(loadingModelIdProvider);
    final isLoading = loadingId == model.id;
    final busy = loadingId != null;
    final cs = Theme.of(context).colorScheme;

    return ListTile(
      selected: isActive,
      hoverColor: cs.primary.withValues(alpha: 0.06),
      leading: Icon(
        isActive ? Icons.check_circle : Icons.dns_outlined,
        color: isActive ? cs.primary : null,
      ),
      title: Text(model.name),
      subtitle: Text(
        model.isInstalled ? model.key! : 'No file — re-add from disk',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onOpen,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: model.isLiked ? 'Unfavorite' : 'Favorite',
            icon: Icon(model.isLiked ? Icons.favorite : Icons.favorite_border),
            color: model.isLiked ? cs.error : null,
            onPressed: () => ctrl.toggleLike(model),
          ),
          _action(context, ctrl, isActive, isLoading, busy),
          IconButton(
            tooltip: 'Remove',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => confirmModelDelete(context, ctrl, model),
          ),
        ],
      ),
    );
  }

  Widget _action(
    BuildContext context,
    ModelsController ctrl,
    bool isActive,
    bool isLoading,
    bool busy,
  ) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(10),
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    if (isActive) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text('Active'),
      );
    }
    return TextButton.icon(
      onPressed: (!model.isInstalled || busy)
          ? null
          : () => runModelLoad(ScaffoldMessenger.of(context), ctrl, model),
      icon: const Icon(Icons.play_arrow, size: 18),
      label: const Text('Load'),
    );
  }
}
