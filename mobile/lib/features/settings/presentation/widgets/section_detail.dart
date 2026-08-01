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

class SectionDetail extends ConsumerWidget {
  const SectionDetail({super.key, required this.sectionId});

  final String sectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final section = ref.watch(settingsSectionsProvider).firstWhere(
          (s) => s.id == sectionId,
          orElse: () => ref.watch(settingsSectionsProvider).first,
        );
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      children: [
        Text(sectionLabel(l10n, section.id),
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(
          sectionSubtitle(l10n, section.id),
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 20),
        _bodyFor(section.id),
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
