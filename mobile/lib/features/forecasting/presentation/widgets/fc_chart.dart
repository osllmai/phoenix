import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/forecast_data.dart';

/// History line + P50 forecast + shaded P10–P90 band, split by a "now" divider.
/// Built with fl_chart so the forecast is touch-interactive (per-step tooltips).
class FcChart extends StatelessWidget {
  const FcChart({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hist = ForecastSample.history;
    final p50 = ForecastSample.p50;
    final p10 = ForecastSample.p10;
    final p90 = ForecastSample.p90;
    final nH = hist.length;
    final now = (nH - 1).toDouble();
    final anchor = FlSpot(now, hist[nH - 1]); // join history → forecast at "now"

    List<FlSpot> fc(List<double> v) =>
        [anchor, for (var i = 0; i < v.length; i++) FlSpot((nH + i).toDouble(), v[i])];

    final all = [...hist, ...p90, ...p10];
    final lo = all.reduce((a, b) => a < b ? a : b);
    final hi = all.reduce((a, b) => a > b ? a : b);
    final pad = (hi - lo) * 0.08;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 640 / 300,
          child: LineChart(LineChartData(
            minX: 0,
            maxX: (nH + p50.length - 1).toDouble(),
            minY: lo - pad,
            maxY: hi + pad,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: const FlTitlesData(show: false),
            betweenBarsData: [
              BetweenBarsData(
                  fromIndex: 1, toIndex: 2, color: scheme.primary.withValues(alpha: 0.18)),
            ],
            extraLinesData: ExtraLinesData(verticalLines: [
              VerticalLine(
                x: now,
                color: scheme.outline,
                strokeWidth: 1,
                dashArray: const [3, 3],
                label: VerticalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  labelResolver: (_) => ' now',
                  style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 10),
                ),
              ),
            ]),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (spots) => spots.map((s) {
                  if (s.barIndex == 1 || s.barIndex == 2) return null;
                  final label = s.barIndex == 0 ? 'Hist' : 'P50';
                  return LineTooltipItem('$label ${s.y.toStringAsFixed(1)}',
                      TextStyle(color: scheme.onSurface, fontSize: 12));
                }).toList(),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [for (var i = 0; i < nH; i++) FlSpot(i.toDouble(), hist[i])],
                color: scheme.onSurfaceVariant,
                barWidth: 2,
                dotData: const FlDotData(show: false),
              ),
              LineChartBarData(
                spots: fc(p10),
                color: Colors.transparent,
                barWidth: 0,
                dotData: const FlDotData(show: false),
              ),
              LineChartBarData(
                spots: fc(p90),
                color: Colors.transparent,
                barWidth: 0,
                dotData: const FlDotData(show: false),
              ),
              LineChartBarData(
                spots: fc(p50),
                color: scheme.primary,
                barWidth: 2.5,
                dashArray: const [6, 4],
                dotData: const FlDotData(show: false),
              ),
            ],
          )),
        ),
        const SizedBox(height: 10),
        Wrap(spacing: 16, runSpacing: 6, children: [
          _Key(color: scheme.onSurfaceVariant, label: 'History'),
          _Key(color: scheme.primary, label: 'Forecast (P50)'),
          _Key(color: scheme.primary.withValues(alpha: 0.3), label: 'P10–P90 interval'),
        ]),
      ],
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 14, height: 4, color: color),
      const SizedBox(width: 6),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ]);
  }
}
