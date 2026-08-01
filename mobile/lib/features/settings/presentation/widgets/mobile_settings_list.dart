import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../providers/settings_sections.dart';
import 'about_section.dart';
import 'appearance_section.dart';
import 'backend_section.dart';
import 'engine_section.dart';
import 'general_section.dart';
import 'privacy_section.dart';
import 'section_l10n.dart';
import 'storage_section.dart';

/// Phone layout: every section stacked in one scrolling column of grouped tiles.
class MobileSettingsList extends ConsumerWidget {
  const MobileSettingsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(settingsSectionsProvider);
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        for (final s in sections) ...[
          Text(sectionLabel(l10n, s.id),
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 2),
          Text(
            sectionSubtitle(l10n, s.id),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 12),
          _bodyFor(s.id),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _bodyFor(String id) {
    switch (id) {
      case 'general':
        return const GeneralSection();
      case 'engine':
        return const EngineSection();
      case 'privacy':
        return const PrivacySection();
      case 'storage':
        return const StorageSection();
      case 'backend':
        return const BackendSection();
      case 'about':
        return const AboutSection();
      case 'appearance':
      default:
        return const AppearanceSection();
    }
  }
}
