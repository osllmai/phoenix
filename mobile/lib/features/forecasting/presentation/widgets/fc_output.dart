import 'package:flutter/material.dart';

import '../data/forecast_data.dart';

/// Forecast summary stats, the per-step P10/P50/P90 table and the
/// not-financial-advice disclaimer.
class FcOutput extends StatelessWidget {
  const FcOutput({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(spacing: 12, runSpacing: 12, children: [
          for (final s in ForecastSample.stats)
            Container(
              width: 150,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.label,
                    style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                const SizedBox(height: 4),
                Text(s.value,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ]),
            ),
        ]),
        const SizedBox(height: 16),
        DataTable(
          columnSpacing: 28,
          headingRowHeight: 36,
          dataRowMinHeight: 32,
          dataRowMaxHeight: 40,
          columns: const [
            DataColumn(label: Text('Step')),
            DataColumn(label: Text('P10')),
            DataColumn(label: Text('P50')),
            DataColumn(label: Text('P90')),
          ],
          rows: [
            for (final r in ForecastSample.rows)
              DataRow(cells: [
                DataCell(Text(r.step)),
                DataCell(Text(r.p10)),
                DataCell(Text(r.p50)),
                DataCell(Text(r.p90)),
              ]),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('⚠ '),
            Expanded(
              child: Text(
                'Forecasts are probabilistic estimates from TimesFM — not '
                'financial, investment, or trading advice. Markets are uncertain; '
                'verify independently before acting.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
