import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_core/phoenix_core.dart';

import '../providers/model_providers.dart';
import 'model_picker.dart';

/// Global rail indicator showing the currently selected model (local or cloud).
/// Tap opens the model picker.
class ActiveModelChip extends ConsumerWidget {
  const ActiveModelChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(selectedModelProvider);
    final cs = Theme.of(context).colorScheme;
    final isCloud = selection?.mode == ComputeMode.cloud;
    return Tooltip(
      message: selection?.name ?? 'No model selected',
      child: InkWell(
        onTap: () => showModelPicker(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCloud ? Icons.cloud_outlined : Icons.computer,
                size: 20,
                color: selection != null ? cs.primary : cs.onSurfaceVariant,
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 76,
                child: Text(
                  selection?.name ?? 'None',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
