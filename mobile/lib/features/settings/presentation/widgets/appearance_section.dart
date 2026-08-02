import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/fonts.dart';
import '../../../../app/theme.dart';
import '../providers/settings_controller.dart';
import '../providers/settings_state.dart';
import 'font_picker.dart';
import 'setting_controls.dart';
import 'setting_field.dart';
import 'theme_gallery.dart';

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
          description: 'Warm-charcoal dark, light, or follow OS',
          control: SettingPills(
            options: const ['Dark', 'Light', 'System'],
            selected: s.theme.index,
            onSelected: (i) => ctrl.setTheme(AppThemeMode.values[i]),
          ),
        ),
        SettingField(
          name: 'Font',
          description: 'Search any Google font; bundled work offline',
          control: _FontButton(family: s.fontFamily, ctrl: ctrl),
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
            colors: kAccentColors,
            selected: s.accentIndex,
            onSelected: ctrl.setAccent,
          ),
        ),
        SettingField(
          name: 'Color theme',
          description: 'Shared palettes that re-theme the whole app',
          control: ThemeGallery(
            selected: s.colorTheme,
            onSelected: ctrl.setColorTheme,
          ),
        ),
      ],
    );
  }
}

String _fontLabel(String family) {
  for (final e in kFontOptions.entries) {
    if (e.value == family) return e.key;
  }
  return family;
}

class _FontButton extends StatelessWidget {
  const _FontButton({required this.family, required this.ctrl});

  final String family;
  final SettingsController ctrl;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return OutlinedButton.icon(
      onPressed: () => showFontPicker(
        context: context,
        selected: family,
        onSelected: ctrl.setFontFamily,
        onFetchFailed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Couldn't download that font — try again when you're online.",
            ),
          ),
        ),
      ),
      icon: Icon(
        isBundledFont(family)
            ? Icons.offline_pin_outlined
            : Icons.cloud_done_outlined,
        size: 18,
        color: scheme.onSurfaceVariant,
      ),
      label: Text(_fontLabel(family),
          style: TextStyle(fontFamily: isBundledFont(family) ? family : null)),
    );
  }
}
