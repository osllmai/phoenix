import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_controller.dart';
import '../providers/settings_state.dart';
import 'setting_controls.dart';
import 'setting_field.dart';
import 'setting_inputs.dart';
import 'setting_text_field.dart';

const _databases = ['SQLite (on-device)', 'Postgres'];

class BackendSection extends ConsumerWidget {
  const BackendSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsControllerProvider).value ??
        const SettingsState();
    final ctrl = ref.read(settingsControllerProvider.notifier);
    return SettingGroup(
      children: [
        SettingField(
          name: 'Database',
          description: 'Conversation & model metadata storage',
          control: SettingPills(
            options: _databases,
            selected: _databases.indexOf(s.database).clamp(0, _databases.length - 1),
            onSelected: (i) => ctrl.setDatabase(_databases[i]),
          ),
        ),
        SettingField(
          name: 'DATABASE_URL',
          description: 'Used only when Postgres is selected',
          control: SettingTextField(
            value: s.databaseUrl,
            enabled: s.database == 'Postgres',
            hint: 'postgresql://user:pass@localhost:5432/phoenix',
            onChanged: ctrl.setDatabaseUrl,
          ),
        ),
        SettingField(
          name: 'Server port',
          description: 'Local OpenAI/Anthropic-compatible gateway',
          control: SettingNumberField(
            value: s.serverPort,
            onChanged: ctrl.setServerPort,
          ),
        ),
        SettingField(
          name: 'Base URL',
          description: 'Derived endpoint for local API clients',
          control: SettingStaticText(value: 'http://localhost:${s.serverPort}'),
        ),
      ],
    );
  }
}
