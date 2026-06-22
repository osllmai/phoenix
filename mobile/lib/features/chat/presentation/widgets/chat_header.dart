import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_core/phoenix_core.dart';

import '../../../models/presentation/providers/model_providers.dart';
import '../../../models/presentation/widgets/model_picker.dart';

/// The conversation header: a model picker (active model + quick switch) and a
/// conversation-parameters button. A menu button leads on phone.
class ChatHeader extends ConsumerWidget {
  const ChatHeader({super.key, this.onMenu});

  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final selection = ref.watch(selectedModelProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          if (onMenu != null)
            IconButton(onPressed: onMenu, icon: const Icon(Icons.menu)),
          Flexible(child: _ModelSwitch(selection: selection)),
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

class _ModelSwitch extends StatelessWidget {
  const _ModelSwitch({required this.selection});

  final SelectedModel? selection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final loaded = selection != null;
    final isCloud = selection?.mode == ComputeMode.cloud;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => showModelPicker(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isCloud ? Icons.cloud_outlined : Icons.computer,
              size: 18,
              color: loaded ? scheme.primary : scheme.outline,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                selection?.name ?? 'Select a model',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
