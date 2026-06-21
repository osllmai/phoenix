import 'package:flutter/material.dart';

import '../data/evaluators_sample.dart';

class MetricRow extends StatelessWidget {
  const MetricRow({super.key, required this.metric});

  final EvaluatorMetric metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = _statusColor(metric.status, scheme);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(metric.label, style: theme.textTheme.bodyMedium),
              ),
              Text(
                metric.value,
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontFamily: 'monospace'),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: metric.fraction.clamp(0.0, 1.0),
              minHeight: 7,
              backgroundColor: scheme.surfaceContainerHighest,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _statusLabel(metric.status),
                style: theme.textTheme.labelSmall?.copyWith(color: color),
              ),
              Text(
                metric.threshold,
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Color _statusColor(MetricStatus status, ColorScheme scheme) {
  switch (status) {
    case MetricStatus.pass:
      return scheme.tertiary;
    case MetricStatus.warn:
      return scheme.primary;
    case MetricStatus.fail:
      return scheme.error;
  }
}

String _statusLabel(MetricStatus status) {
  switch (status) {
    case MetricStatus.pass:
      return 'PASS';
    case MetricStatus.warn:
      return 'WARN';
    case MetricStatus.fail:
      return 'FAIL';
  }
}
