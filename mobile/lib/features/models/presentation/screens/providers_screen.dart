import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/radiant.dart';
import '../../data/providers_stub.dart';
import '../widgets/providers/add_provider_dialog.dart';
import '../widgets/providers/models_tab_bar.dart';
import '../widgets/providers/providers_centered.dart';
import '../widgets/providers/providers_loading.dart';
import '../widgets/providers/providers_success.dart';

/// Models › Providers — IndoxHub gateway + BYOK provider keys. Stubbed until the
/// providers backend lands; a state switcher exposes every mock state.
class ProvidersScreen extends ConsumerWidget {
  const ProvidersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final view = ref.watch(providersViewProvider);

    final body = switch (view) {
      ProvidersView.success || ProvidersView.add => const ProvidersSuccess(
        gateway: gatewayConnected,
        providers: successProviders,
      ),
      ProvidersView.empty => const ProvidersEmpty(),
      ProvidersView.firstRun => const ProvidersFirstRun(),
      ProvidersView.loading => const ProvidersLoading(),
      ProvidersView.error => const ProvidersSuccess(
        gateway: gatewayError,
        providers: errorProviders,
        countLabel: '1 connected · 1 failed',
      ),
      ProvidersView.denied => const ProvidersSuccess(
        gateway: gatewayDenied,
        providers: deniedProviders,
        countLabel: '1 connected · 1 denied',
      ),
    };

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RadiantBackdrop(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ModelsTabBar(activePath: '/models/providers'),
              _header(context, ref, theme),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, WidgetRef ref, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'Providers & API Keys',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (kDebugMode) _stateSwitcher(ref),
              OutlinedButton(onPressed: () {}, child: const Text('Test all')),
              FilledButton.icon(
                onPressed: () => showAddProviderDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add provider'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stateSwitcher(WidgetRef ref) => PopupMenuButton<ProvidersView>(
    tooltip: 'Preview state',
    icon: const Icon(Icons.layers_outlined),
    onSelected: (v) => ref.read(providersViewProvider.notifier).state = v,
    itemBuilder: (_) => [
      for (final v in ProvidersView.values)
        if (v != ProvidersView.add)
          PopupMenuItem(value: v, child: Text(v.name)),
    ],
  );
}
