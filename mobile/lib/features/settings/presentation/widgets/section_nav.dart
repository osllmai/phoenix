import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_controller.dart';
import '../providers/settings_sections.dart';

/// The section list pane: pick a settings group. Drives the detail pane.
class SectionNav extends ConsumerWidget {
  const SectionNav({super.key, this.onSelected});

  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(settingsSectionsProvider);
    final active = ref.watch(
      settingsControllerProvider
          .select((s) => s.value?.activeSection ?? 'appearance'),
    );
    final ctrl = ref.read(settingsControllerProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'SETTINGS',
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: scheme.onSurfaceVariant, letterSpacing: 1.2),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              for (final s in sections)
                _NavTile(
                  section: s,
                  selected: s.id == active,
                  onTap: () {
                    ctrl.openSection(s.id);
                    onSelected?.call();
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  final SettingsSection section;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      selected: selected,
      selectedTileColor: scheme.primaryContainer,
      leading: Icon(section.icon),
      title: Text(section.label),
      onTap: onTap,
    );
  }
}
