import 'package:flutter/material.dart';

/// Data-source picker, series list and forecast-settings fields. Lives inside
/// the collapsible "Forecast setup" panel; the Run action sits outside it.
class FcControls extends StatelessWidget {
  const FcControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(context, 'Data source'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final s in const ['⬆ Upload', 'IBKR', 'Webull', 'Alpaca', 'Yahoo'])
            ChoiceChip(label: Text(s), selected: s == '⬆ Upload', onSelected: (_) {}),
        ]),
        const SizedBox(height: 16),
        _label(context, 'Series'),
        for (final v in const [
          ('AAPL · 1D', '504 bars · daily · close · IBKR', true),
          ('retail_sales.csv', '312 · weekly · upload', false),
          ('api_latency_p95', '2,016 · hourly', false),
        ])
          _SeriesRow(name: v.$1, meta: v.$2, selected: v.$3),
        const SizedBox(height: 16),
        _label(context, 'Forecast settings'),
        Wrap(spacing: 12, runSpacing: 12, crossAxisAlignment: WrapCrossAlignment.end, children: [
          _Field(label: 'Frequency', value: 'Daily (D)'),
          _Field(label: 'Context', value: '512'),
          _Field(label: 'Horizon', value: '24'),
          _Field(label: 'Quantiles', value: '10 / 50 / 90'),
        ]),
      ],
    );
  }

  Widget _label(BuildContext context, String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(t.toUpperCase(),
            style: TextStyle(
                fontSize: 11,
                letterSpacing: 1.1,
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
      );
}

class _SeriesRow extends StatelessWidget {
  const _SeriesRow({required this.name, required this.meta, required this.selected});
  final String name;
  final String meta;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? scheme.primaryContainer : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: selected ? Border.all(color: scheme.primary) : null,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        Text(meta, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
      ]),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
      const SizedBox(height: 4),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: scheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(value, style: const TextStyle(fontSize: 13)),
      ),
    ]);
  }
}
