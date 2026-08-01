import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/presentation/providers/default_model.dart';
import '../providers/settings_controller.dart';
import '../providers/settings_state.dart';
import 'setting_controls.dart';
import 'setting_field.dart';
import 'setting_inputs.dart';

const _languages = ['English (US)', 'Français', 'Deutsch', '日本語'];
const _startupViews = ['Home dashboard', 'Last conversation', 'New chat'];
const _defaultModels = [
  'Llama-3.1-8B-Instruct · Q4_K_M',
  'Mistral-7B-Instruct · Q5_K_M',
  'Phi-3-mini-4k · Q8_0',
  noDefaultModelOption,
];

class GeneralSection extends ConsumerWidget {
  const GeneralSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsControllerProvider).value ??
        const SettingsState();
    final ctrl = ref.read(settingsControllerProvider.notifier);
    return SettingGroup(
      children: [
        SettingField(
          name: 'Language',
          description: 'Interface language',
          control: SettingOptionsDropdown(
            options: _languages,
            value: s.language,
            onChanged: ctrl.setLanguage,
          ),
        ),
        SettingField(
          name: 'On startup',
          description: 'What Phoenix opens to',
          control: SettingOptionsDropdown(
            options: _startupViews,
            value: s.startupView,
            onChanged: ctrl.setStartupView,
          ),
        ),
        SettingField(
          name: 'Default model',
          description: 'Loaded on startup unless overridden per chat',
          control: SettingOptionsDropdown(
            options: _defaultModels,
            value: s.defaultModel,
            onChanged: ctrl.setDefaultModel,
          ),
        ),
        SettingField(
          name: 'Launch at login',
          description: 'Start Phoenix when you sign in',
          control: SettingToggle(
            value: s.launchAtLogin,
            onChanged: ctrl.setLaunchAtLogin,
          ),
        ),
      ],
    );
  }
}
