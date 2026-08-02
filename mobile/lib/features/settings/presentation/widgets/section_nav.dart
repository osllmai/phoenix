import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/radiant.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/settings_controller.dart';
import '../providers/settings_sections.dart';
import 'section_l10n.dart';

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
    final iconColor =
        selected ? radiantSelectedInk(scheme) : scheme.onSurfaceVariant;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: selected ? radiantNeutralHighlight(scheme) : null,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(section.icon, color: iconColor),
        title: Text(
          sectionLabel(AppLocalizations.of(context), section.id),
          style: TextStyle(
            color: selected ? scheme.onSurface : null,
            fontWeight: selected ? FontWeight.w600 : null,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
