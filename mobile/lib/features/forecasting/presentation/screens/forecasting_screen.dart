import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/widgets/use_desktop_or_subscribe.dart';
import '../providers/forecast_view.dart';
import '../widgets/fc_chart.dart';
import '../widgets/fc_controls.dart';
import '../widgets/fc_header.dart';
import '../widgets/fc_output.dart';
import '../widgets/fc_states.dart';

/// Forecasting (TimesFM). The UI is a full PREVIEW; running a forecast needs the
/// paired desktop backend, so on mobile the Run action gates to "use desktop or
/// subscribe". States (success/pair/loading/error) mirror the design mock.
class ForecastingScreen extends ConsumerWidget {
  const ForecastingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(forecastViewProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: FcHeader(),
            ),
            const Divider(height: 1),
            Expanded(child: _body(context, view)),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context, ForecastView view) => switch (view) {
        ForecastView.firstRun => const SingleChildScrollView(child: FcFirstRun()),
        ForecastView.success => _success(context),
        ForecastView.denied => const SingleChildScrollView(child: FcPair()),
        ForecastView.loading => const FcLoading(),
        ForecastView.error => const SingleChildScrollView(child: FcError()),
      };

  Widget _success(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _setupPanel(context),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: () => _run(context),
            icon: const Icon(Icons.play_arrow, size: 18),
            label: const Text('Run on desktop'),
          ),
        ),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(
            child: Text('AAPL · 1D — 24-step forecast',
                style: theme.textTheme.titleMedium),
          ),
          TextButton.icon(
            onPressed: () => _run(context),
            icon: const Icon(Icons.download, size: 18),
            label: const Text('Export CSV'),
          ),
        ]),
        const SizedBox(height: 12),
        const FcChart(),
        const SizedBox(height: 24),
        const FcOutput(),
      ],
    );
  }

  /// Collapsible "Forecast setup" panel — keeps every control but tidies the top.
  Widget _setupPanel(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.hardEdge,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          trailing: Icon(Icons.edit_outlined, size: 18, color: scheme.primary),
          title: Row(children: [
            const Text('Forecast setup',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(width: 12),
            Expanded(
              child: Text('AAPL · 1D · context 512 → horizon 24 · P10/50/90',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13)),
            ),
          ]),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: const [FcControls()],
        ),
      ),
    );
  }

  void _run(BuildContext context) {
    if (isDesktopPlatform) return;
    showUseDesktopOrSubscribe(context, feature: 'Forecasting');
  }
}
