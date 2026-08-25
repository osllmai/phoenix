import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/env.dart';
import 'dashboard_state.dart';

part 'dashboard_controller.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  @override
  DashboardState build() {
    return DashboardState(
      serverRunning: true,
      serverEndpoint: gatewayHostPort,
      stats: [
        DashboardStat(
          label: 'Installed models',
          value: '0',
          unit: 'local',
          icon: '🧠',
        ),
        DashboardStat(
          label: 'Storage used',
          value: '24.8',
          unit: 'GB',
          icon: '💾',
        ),
        DashboardStat(
          label: 'Tokens today',
          value: '128.4',
          unit: 'k',
          icon: '⚡',
        ),
      ],
      resources: [
        ResourceMeter(label: 'VRAM', fraction: 0.68, detail: '5.4 / 8.0 GB'),
        ResourceMeter(label: 'RAM', fraction: 0.41, detail: '13.1 / 32 GB'),
        ResourceMeter(label: 'Disk', fraction: 0.84, detail: '421 / 500 GB'),
      ],
    );
  }

  void refresh() => ref.invalidateSelf();
}
