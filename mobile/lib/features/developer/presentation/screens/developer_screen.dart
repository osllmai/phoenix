import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../providers/server_console_controller.dart';
import '../providers/server_health_provider.dart';
import '../widgets/desktop_only_stub.dart';
import '../widgets/endpoints_card.dart';
import '../widgets/request_log_panel.dart';
import '../widgets/server_down_panel.dart';
import '../widgets/server_status_grid.dart';
import '../widgets/server_toolbar.dart';

/// Developer / server console. Desktop shows the live gateway console (status,
/// endpoints, request log); tablet/phone show a companion stub per the platform
/// split — the server only runs on desktop.
class DeveloperScreen extends ConsumerWidget {
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ff = formFactorOf(context);

    if (!isDesktopPlatform) {
      return const Scaffold(body: SafeArea(child: DesktopOnlyStub()));
    }

    final stats = ref.watch(serverConsoleControllerProvider).stats;
    final endpoints = ref.watch(serverConsoleControllerProvider).endpoints;
    final reachable = ref.watch(serverHealthProvider).value?.reachable ?? false;
    final cols = ff.isDesktop ? 4 : 2;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Header(),
            const Divider(height: 1),
            const ServerToolbar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (reachable)
                      ServerStatusGrid(stats: stats, columns: cols)
                    else
                      const ServerDownPanel(),
                    const SizedBox(height: 16),
                    EndpointsCard(endpoints: endpoints),
                    const SizedBox(height: 16),
                    const RequestLogPanel(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.terminal),
          const SizedBox(width: 8),
          Text('Developer · Server',
              style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
