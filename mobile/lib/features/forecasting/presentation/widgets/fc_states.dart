import 'package:flutter/material.dart';

import '../../../../core/widgets/use_desktop_or_subscribe.dart';

/// New user, no data yet — the default Forecasting view. No sample data is
/// shown so the screen never looks like it holds the user's own forecast.
class FcFirstRun extends StatelessWidget {
  const FcFirstRun({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return _Center(children: [
      const Text('📈', style: TextStyle(fontSize: 48)),
      const SizedBox(height: 12),
      Text('Forecast your first series', style: theme.textTheme.titleLarge),
      const SizedBox(height: 10),
      Text(
        'Upload a CSV or connect a data source (IBKR, Webull, Alpaca, Yahoo), '
        'then run a TimesFM forecast on your paired desktop.',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      const SizedBox(height: 20),
      Wrap(spacing: 12, runSpacing: 12, alignment: WrapAlignment.center, children: [
        FilledButton.icon(
          onPressed: () => showUseDesktopOrSubscribe(context, feature: 'Forecasting'),
          icon: const Icon(Icons.upload_file, size: 18),
          label: const Text('Upload a CSV'),
        ),
        OutlinedButton(
          onPressed: () => showUseDesktopOrSubscribe(context, feature: 'Forecasting'),
          child: const Text('Connect a source'),
        ),
      ]),
      const SizedBox(height: 14),
      Text('No sample data is loaded — your forecast appears here once you run one.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
    ]);
  }
}

/// "Pair a desktop to forecast" — shown when no desktop is paired.
class FcPair extends StatelessWidget {
  const FcPair({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return _Center(children: [
      const Text('🔗', style: TextStyle(fontSize: 48)),
      const SizedBox(height: 12),
      Text('Pair a desktop to forecast', style: theme.textTheme.titleLarge),
      const SizedBox(height: 10),
      Text(
        'TimesFM runs as a PyTorch/Celery job on a paired Phoenix desktop — the '
        'tablet sends the series and views results. Pair a workbench on the same '
        'network to run forecasts.',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      const SizedBox(height: 20),
      FilledButton(
        onPressed: () => showUseDesktopOrSubscribe(context, feature: 'Forecasting'),
        child: const Text('Pair a desktop'),
      ),
    ]);
  }
}

/// Forecast running on the paired desktop's backend.
class FcLoading extends StatelessWidget {
  const FcLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return _Center(children: [
      const SizedBox(
          width: 44, height: 44, child: CircularProgressIndicator(strokeWidth: 3)),
      const SizedBox(height: 16),
      Text('Running on desktop', style: theme.textTheme.titleMedium),
      const SizedBox(height: 8),
      Text('AAPL · 1D · 512 → 24 · encoding context · sampling quantiles…',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
    ]);
  }
}

/// Forecast failed (e.g. series parse error).
class FcError extends StatelessWidget {
  const FcError({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return _Center(children: [
      const Text('⚠️', style: TextStyle(fontSize: 48)),
      const SizedBox(height: 12),
      Text('Forecast failed', style: theme.textTheme.titleLarge),
      const SizedBox(height: 10),
      Text(
        "The series couldn't be parsed. TimesFM needs a regular timestamp column "
        'and a numeric value column; non-numeric values are rejected.',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      const SizedBox(height: 20),
      OutlinedButton.icon(
        onPressed: () => showUseDesktopOrSubscribe(context, feature: 'Forecasting'),
        icon: const Icon(Icons.refresh, size: 18),
        label: const Text('Retry'),
      ),
    ]);
  }
}

class _Center extends StatelessWidget {
  const _Center({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        ),
      ),
    );
  }
}
