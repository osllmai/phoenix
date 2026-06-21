import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_controller.dart';
import '../providers/settings_state.dart';
import 'setting_controls.dart';
import 'setting_field.dart';

const _accents = [
  Color(0xFFFF8A3D),
  Color(0xFF7FB069),
  Color(0xFF5AA9E6),
  Color(0xFFB57EDC),
  Color(0xFFE6B95A),
];

class AppearanceSection extends ConsumerWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsControllerProvider).value ??
        const SettingsState();
    final ctrl = ref.read(settingsControllerProvider.notifier);
    return SettingGroup(
      children: [
        SettingField(
          name: 'Theme',
          description: 'Warm-charcoal dark, cream light, or follow OS',
          control: SettingPills(
            options: const ['Dark', 'Cream', 'System'],
            selected: s.theme.index,
            onSelected: (i) => ctrl.setTheme(AppThemeMode.values[i]),
          ),
        ),
        SettingField(
          name: 'Font size',
          description: 'Base UI and prose scale',
          control: SettingSlider(
            value: s.fontSize,
            min: 12,
            max: 20,
            unit: 'px',
            onChanged: ctrl.setFontSize,
          ),
        ),
        SettingField(
          name: 'Accent color',
          description: 'Highlights and interactive elements',
          control: SettingSwatches(
            colors: _accents,
            selected: s.accentIndex,
            onSelected: ctrl.setAccent,
          ),
        ),
      ],
    );
  }
}
