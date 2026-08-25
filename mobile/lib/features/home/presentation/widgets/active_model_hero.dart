import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_core/phoenix_core.dart';

import '../../../models/presentation/providers/model_providers.dart';
import '../../../models/presentation/widgets/model_picker.dart';
import 'hero_throughput.dart';

class ActiveModelHero extends ConsumerWidget {
  const ActiveModelHero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final selection = ref.watch(selectedModelProvider);
    final loaded = selection != null;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [scheme.primaryContainer, scheme.surfaceContainer],
        ),
        border: Border.all(color: scheme.primary),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _HeroRow(selection: selection),
          if (loaded) ...[
            const SizedBox(height: 16),
            const HeroThroughput(),
          ],
        ],
      ),
    );
  }
}

class _HeroRow extends StatelessWidget {
  const _HeroRow({required this.selection});

  final SelectedModel? selection;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final loaded = selection != null;
    final isCloud = selection?.mode == ComputeMode.cloud;
    final identity = Row(
      children: [
        Opacity(
          opacity: loaded ? 1 : 0.5,
          child: Icon(
            isCloud ? Icons.cloud_outlined : Icons.computer,
            size: 32,
            color: scheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loaded ? selection!.name : 'No model selected',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: loaded ? null : scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                loaded
                    ? (isCloud ? 'Cloud · via IndoxHub' : 'Local · on-device')
                    : 'Pick a model to start chatting',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
    final action = FilledButton.icon(
      onPressed: () => showModelPicker(context),
      icon: Icon(loaded ? Icons.swap_horiz : Icons.add, size: 16),
      label: Text(loaded ? 'Switch' : 'Pick a model',
          maxLines: 1, overflow: TextOverflow.ellipsis),
    );

    return LayoutBuilder(
      builder: (context, constraints) => constraints.maxWidth < _stackBelow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [identity, const SizedBox(height: 12), action],
            )
          : Row(
              children: [
                Expanded(child: identity),
                const SizedBox(width: 12),
                action,
              ],
            ),
    );
  }
}

/// Below this the identity text and the action button can't share a row without
/// the button's label overflowing, so the button drops beneath it.
const double _stackBelow = 420;
