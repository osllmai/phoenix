import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/presentation/providers/model_providers.dart';
import 'hero_throughput.dart';

class ActiveModelHero extends ConsumerWidget {
  const ActiveModelHero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final active = ref.watch(activeModelProvider);
    final loaded = active != null;

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
          _HeroRow(loaded: loaded, name: active?.name),
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
  const _HeroRow({required this.loaded, this.name});

  final bool loaded;
  final String? name;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Opacity(
          opacity: loaded ? 1 : 0.5,
          child: const Text('🧠', style: TextStyle(fontSize: 32)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loaded ? name! : 'No model loaded',
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
                    ? 'Loaded · ready · Q4_K_M · 8K context'
                    : 'Load a model to start chatting',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: FilledButton.icon(
            onPressed: () {},
            icon: Icon(loaded ? Icons.chat_bubble_outline : Icons.download,
                size: 16),
            label: Text(loaded ? 'New chat' : 'Load a model',
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    );
  }
}
