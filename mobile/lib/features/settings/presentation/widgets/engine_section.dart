import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_controller.dart';
import '../providers/settings_state.dart';
import 'setting_controls.dart';
import 'setting_field.dart';

const _ctxOptions = [2048, 4096, 8192, 16384, 32768];

class EngineSection extends ConsumerWidget {
  const EngineSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsControllerProvider).value ??
        const SettingsState();
    final ctrl = ref.read(settingsControllerProvider.notifier);
    return Column(
      children: [
        SettingGroup(
          title: 'Inference',
          children: [
            SettingField(
              name: 'Context length',
              description: 'nCtx — max token window per session',
              control: DropdownButton<int>(
                value: s.contextLength,
                items: [
                  for (final c in _ctxOptions)
                    DropdownMenuItem(value: c, child: Text('$c')),
                ],
                onChanged: (v) => v == null ? null : ctrl.setContextLength(v),
              ),
            ),
            SettingField(
              name: 'GPU layers',
              description: 'numberOfGpuLayers — 0 = CPU only',
              control: SettingSlider(
                value: s.gpuLayers.toDouble(),
                min: 0,
                max: 99,
                onChanged: (v) => ctrl.setGpuLayers(v.round()),
              ),
            ),
            SettingField(
              name: 'CPU threads',
              description: 'nThread — parallel decode threads',
              control: SettingSlider(
                value: s.cpuThreads.toDouble(),
                min: 1,
                max: 32,
                onChanged: (v) => ctrl.setCpuThreads(v.round()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
