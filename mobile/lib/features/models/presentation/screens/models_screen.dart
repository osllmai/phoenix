import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:phoenix_core/phoenix_core.dart';

import '../providers/model_providers.dart';

/// Lists installed local models, lets the user select (load) one, like, remove,
/// or register a new `.gguf` by path.
class ModelsScreen extends ConsumerWidget {
  const ModelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final models = ref.watch(modelsControllerProvider);
    final active = ref.watch(activeModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Models')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add .gguf'),
      ),
      body: models.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) => list.isEmpty
            ? const Center(child: Text('No models yet. Add a .gguf to start.'))
            : ListView(
                children: [
                  for (final m in list)
                    _ModelTile(model: m, isActive: active?.id == m.id),
                ],
              ),
      ),
    );
  }

  Future<void> _addDialog(BuildContext context, WidgetRef ref) async {
    final name = TextEditingController();
    final path = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add local model'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: path, decoration: const InputDecoration(labelText: 'Path to .gguf')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Add')),
        ],
      ),
    );
    if (ok == true && name.text.isNotEmpty && path.text.isNotEmpty) {
      await ref.read(modelsControllerProvider.notifier)
          .addLocal(name: name.text, path: path.text);
    }
  }
}

class _ModelTile extends ConsumerWidget {
  const _ModelTile({required this.model, required this.isActive});

  final AiModel model;
  final bool isActive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(modelsControllerProvider.notifier);
    return ListTile(
      leading: Icon(isActive ? Icons.radio_button_checked : Icons.radio_button_off),
      title: Text(model.name),
      subtitle: Text(model.key ?? 'not installed'),
      onTap: model.isInstalled ? () => ctrl.select(model) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(model.isLiked ? Icons.favorite : Icons.favorite_border),
            onPressed: () => ctrl.toggleLike(model),
          ),
          IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => ctrl.remove(model)),
        ],
      ),
    );
  }
}
