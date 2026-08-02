import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_controller.dart';
import '../providers/settings_state.dart';
import 'setting_controls.dart';
import 'setting_field.dart';
import 'setting_text_field.dart';
import 'settings_actions.dart';

class PrivacySection extends ConsumerWidget {
  const PrivacySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsControllerProvider).value ??
        const SettingsState();
    final ctrl = ref.read(settingsControllerProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            border: Border.all(color: scheme.primary),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lock_outline, color: scheme.onPrimaryContainer),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Inference runs entirely on-device — prompts and responses '
                  'never leave your machine. No account, no telemetry unless '
                  'you opt in below.',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: scheme.onPrimaryContainer),
                ),
              ),
            ],
          ),
        ),
        SettingGroup(
          children: [
            SettingField(
              name: 'Telemetry',
              description: 'Anonymous crash reports — no prompts included',
              control: SettingToggle(
                value: s.telemetry,
                onChanged: ctrl.setTelemetry,
              ),
            ),
            SettingField(
              name: 'Usage analytics',
              description: 'Feature interactions (no conversation content)',
              control: SettingToggle(
                value: s.usageAnalytics,
                onChanged: ctrl.setUsageAnalytics,
              ),
            ),
            SettingField(
              name: 'Data location',
              description: 'Where conversations and metadata live',
              control: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: SettingTextField(
                      value: s.dataLocation,
                      onChanged: ctrl.setDataLocation,
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () =>
                        copyValue(context, s.dataLocation, 'Path copied'),
                    child: const Text('Reveal…'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
