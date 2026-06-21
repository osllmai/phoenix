import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dashboard_state.dart';

part 'dashboard_controller.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  @override
  DashboardState build() {
    return const DashboardState(
      // TODO(real-data): serverRunning/endpoint await the phoenix_server gateway.
      serverRunning: true,
      serverEndpoint: 'localhost:24678',
      stats: [
        // Installed-models value is replaced live from modelsControllerProvider.
        DashboardStat(
          label: 'Installed models',
          value: '0',
          unit: 'local',
          icon: '🧠',
        ),
        // TODO(real-data): storage usage has no on-device source yet.
        DashboardStat(
          label: 'Storage used',
          value: '24.8',
          unit: 'GB',
          icon: '💾',
        ),
        // TODO(real-data): token accounting has no source yet.
        DashboardStat(
          label: 'Tokens today',
          value: '128.4',
          unit: 'k',
          icon: '⚡',
        ),
      ],
      // TODO(real-data): system-resource meters need a host telemetry source.
      resources: [
        ResourceMeter(label: 'VRAM', fraction: 0.68, detail: '5.4 / 8.0 GB'),
        ResourceMeter(label: 'RAM', fraction: 0.41, detail: '13.1 / 32 GB'),
        ResourceMeter(label: 'Disk', fraction: 0.84, detail: '421 / 500 GB'),
      ],
    );
  }

  void refresh() => ref.invalidateSelf();
}
