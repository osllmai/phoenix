import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/presentation/providers/model_providers.dart';
import '../providers/dashboard_controller.dart';
import '../providers/dashboard_state.dart';

class StatCards extends ConsumerWidget {
  const StatCards({super.key, this.columns = 3});

  final int columns;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final base = ref.watch(
      dashboardControllerProvider.select((s) => s.stats),
    );
    final installed = ref.watch(modelsControllerProvider);
    final stats = [
      for (final s in base)
        s.label == 'Installed models'
            ? s.copyWith(
                value: installed.maybeWhen(
                  data: (m) => '${m.length}',
                  orElse: () => '—',
                ),
              )
            : s,
    ];
    if (columns == 1) {
      return Column(
        children: [
          for (final s in stats)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _StatTile(stat: s),
            ),
        ],
      );
    }
    // A tile needs ~180px before its value ellipsizes ("24.8 GB" → "24…"), which
    // is what the S7 in portrait gives three-across.
    return LayoutBuilder(
      builder: (context, c) => Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final s in stats)
            SizedBox(
              width: _tileWidth(c.maxWidth, stats.length),
              child: _StatTile(stat: s),
            ),
        ],
      ),
    );
  }

  double _tileWidth(double available, int count) {
    final perRow = available / count >= 180 ? count : 2;
    return (available - 12 * (perRow - 1)) / perRow;
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.stat});

  final DashboardStat stat;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(stat.icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  stat.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  stat.unit,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            stat.label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
