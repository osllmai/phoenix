import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/dashboard_controller.dart';
import '../providers/dashboard_state.dart';
import 'dashboard_card.dart';

class SystemResources extends ConsumerWidget {
  const SystemResources({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meters = ref.watch(
      dashboardControllerProvider.select((s) => s.resources),
    );
    return DashboardCard(
      title: 'System resources',
      child: Column(
        children: [
          for (final m in meters)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _MeterRow(meter: m),
            ),
        ],
      ),
    );
  }
}

class _MeterRow extends StatelessWidget {
  const _MeterRow({required this.meter});

  final ResourceMeter meter;

  Color _fill(ColorScheme scheme) {
    if (meter.fraction >= 0.8) return scheme.error;
    if (meter.fraction >= 0.6) return scheme.tertiary;
    return scheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        SizedBox(
          width: 56,
          child: Text(
            meter.label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: meter.fraction,
              minHeight: 8,
              backgroundColor: scheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(_fill(scheme)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 92,
          child: Text(
            meter.detail,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ),
      ],
    );
  }
}
