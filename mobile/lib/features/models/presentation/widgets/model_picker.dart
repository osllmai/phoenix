import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_core/phoenix_core.dart';

import '../../data/online_catalog_stub.dart';
import '../providers/model_providers.dart';

const _cloudModels = onlineModels;

Future<void> showModelPicker(BuildContext context) => showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const ModelPicker(),
    );

class ModelPicker extends ConsumerWidget {
  const ModelPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final mode = ref.watch(computeModeProvider);
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: SegmentedButton<ComputeMode>(
                segments: const [
                  ButtonSegment(
                    value: ComputeMode.local,
                    icon: Icon(Icons.computer),
                    label: Text('Local'),
                  ),
                  ButtonSegment(
                    value: ComputeMode.cloud,
                    icon: Icon(Icons.cloud_outlined),
                    label: Text('Cloud'),
                  ),
                ],
                selected: {mode},
                onSelectionChanged: (s) =>
                    ref.read(computeModeProvider.notifier).set(s.first),
              ),
            ),
            Flexible(
              child: mode == ComputeMode.local
                  ? const _LocalList()
                  : const _CloudList(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'Local models keep prompts on-device. Cloud models send your '
                'prompt to IndoxHub.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocalList extends ConsumerWidget {
  const _LocalList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final models = ref.watch(modelsControllerProvider);
    final activeId = ref.watch(activeModelProvider)?.id;
    final selected = ref.watch(selectedModelProvider)?.mode == ComputeMode.local;
    return models.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const _Note('Could not load installed models.'),
      data: (list) => list.isEmpty
          ? const _Note('No models installed yet.')
          : ListView(
              shrinkWrap: true,
              children: [
                for (final m in list)
                  _PickerRow(
                    icon: Icons.computer,
                    title: m.name,
                    selected: selected && m.id == activeId,
                    onTap: () async {
                      await ref
                          .read(modelsControllerProvider.notifier)
                          .select(m);
                      ref
                          .read(computeModeProvider.notifier)
                          .set(ComputeMode.local);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
    );
  }
}

class _CloudList extends ConsumerWidget {
  const _CloudList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(cloudModelProvider)?.id;
    final selected = ref.watch(selectedModelProvider)?.mode == ComputeMode.cloud;
    return ListView(
      shrinkWrap: true,
      children: [
        for (final m in _cloudModels)
          _PickerRow(
            icon: Icons.cloud_outlined,
            title: m.name,
            subtitle: m.providerId,
            selected: selected && m.id == selectedId,
            onTap: () {
              final cloud =
                  CloudModel(id: m.id, name: m.name, provider: m.providerId);
              ref.read(cloudModelProvider.notifier).set(cloud);
              ref.read(computeModeProvider.notifier).set(ComputeMode.cloud);
              Navigator.of(context).pop();
            },
          ),
      ],
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: selected ? scheme.primary : scheme.onSurfaceVariant),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: selected ? Icon(Icons.check, color: scheme.primary) : null,
      selected: selected,
      selectedTileColor: scheme.primaryContainer.withValues(alpha: 0.4),
      onTap: onTap,
    );
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Text(text, textAlign: TextAlign.center),
      );
}
