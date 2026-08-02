import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_core/phoenix_core.dart';

import '../../../models/data/device_capabilities.dart';
import '../providers/settings_controller.dart';
import '../providers/settings_state.dart';
import 'context_length_field.dart';
import 'setting_controls.dart';
import 'setting_field.dart';
import 'setting_inputs.dart';

const _chatModels = [
  'Llama-3.1-8B-Instruct · Q4_K_M',
  'Mistral-7B-Instruct · Q5_K_M',
  'Phi-3-mini-4k · Q8_0',
];
const _embedModels = ['nomic-embed-text-v1.5', 'BAAI/bge-small-en', 'all-MiniLM-L6-v2'];

String _accelLabel(Accelerator a) => a.isGpu ? a.name : 'CPU only';

class EngineSection extends ConsumerWidget {
  const EngineSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsControllerProvider).value ?? const SettingsState();
    final ctrl = ref.read(settingsControllerProvider.notifier);
    final caps = ref.watch(deviceCapabilitiesProvider).value;
    final hasGpu = caps?.hasGpu ?? false;
    final cores = caps?.cpuCores ?? 8;
    final accels = caps?.accelerators ?? const [Accelerator.cpu];
    final options = accels.map(_accelLabel).toList();
    final accelValue = options.contains(s.accelerator) ? s.accelerator : options.first;

    return Column(
      children: [
        SettingGroup(
          title: 'Models',
          children: [
            SettingField(
              name: 'Default chat model',
              description: 'GGUF used for conversation',
              control: SettingOptionsDropdown(
                options: _chatModels,
                value: s.chatModel,
                onChanged: ctrl.setChatModel,
              ),
            ),
            SettingField(
              name: 'Default embedding model',
              description: 'Used for search & document RAG',
              control: SettingOptionsDropdown(
                options: _embedModels,
                value: s.embedModel,
                onChanged: ctrl.setEmbedModel,
              ),
            ),
          ],
        ),
        SettingGroup(
          title: 'Inference',
          children: [
            SettingField(
              name: 'Context length',
              description: 'nCtx — max token window per session (presets or custom)',
              control: ContextLengthField(
                value: s.contextLength,
                onChanged: ctrl.setContextLength,
              ),
            ),
            SettingField(
              name: 'GPU / accelerator',
              description: hasGpu
                  ? 'Device for layer offload'
                  : 'No GPU detected on this device — CPU only',
              control: SettingOptionsDropdown(
                options: options,
                value: accelValue,
                onChanged: ctrl.setAccelerator,
              ),
            ),
            SettingField(
              name: 'GPU layers',
              description: hasGpu
                  ? 'numberOfGpuLayers — 0 = CPU only'
                  : 'Requires a GPU',
              control: hasGpu
                  ? SettingSlider(
                      value: s.gpuLayers.toDouble(),
                      min: 0,
                      max: 99,
                      onChanged: (v) => ctrl.setGpuLayers(v.round()),
                    )
                  : const SettingStaticText(value: '0 · no GPU'),
            ),
            SettingField(
              name: 'CPU threads',
              description: 'nThread — parallel decode threads (max $cores on this device)',
              control: cores < 2
                  ? SettingStaticText(value: '$cores')
                  : SettingSlider(
                      value: s.cpuThreads.clamp(1, cores).toDouble(),
                      min: 1,
                      max: cores.toDouble(),
                      onChanged: (v) => ctrl.setCpuThreads(v.round()),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
