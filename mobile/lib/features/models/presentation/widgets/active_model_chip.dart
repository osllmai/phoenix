import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/model_providers.dart';

/// Global rail indicator showing the currently loaded model (or "None").
/// Tap jumps to the models catalog; hover shows the full name.
class ActiveModelChip extends ConsumerWidget {
  const ActiveModelChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeModelProvider);
    final cs = Theme.of(context).colorScheme;
    return Tooltip(
      message: active?.name ?? 'No model loaded',
      child: InkWell(
        onTap: () => context.go('/models'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.memory,
                size: 20,
                color: active != null ? cs.primary : cs.onSurfaceVariant,
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 76,
                child: Text(
                  active?.name ?? 'None',
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
