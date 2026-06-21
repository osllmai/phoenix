import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/welcome_content.dart';
import '../../providers/welcome_controller.dart';
import '../parts/privacy_point.dart';
import '../parts/telemetry_toggle.dart';

/// Step 3 content — the on-device promises and the telemetry opt-in.
class PrivacyStep extends ConsumerWidget {
  const PrivacyStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(welcomeControllerProvider);
    final controller = ref.read(welcomeControllerProvider.notifier);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final p in privacyPoints) ...[
          PrivacyPointRow(point: p),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 4),
        TelemetryToggle(value: state.telemetry, onChanged: controller.toggleTelemetry),
      ],
    );
  }
}
