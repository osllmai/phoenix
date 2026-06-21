import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_sections.dart';
import 'about_section.dart';
import 'appearance_section.dart';
import 'engine_section.dart';
import 'privacy_section.dart';

class SectionDetail extends ConsumerWidget {
  const SectionDetail({super.key, required this.sectionId});

  final String sectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final section = ref.watch(settingsSectionsProvider).firstWhere(
          (s) => s.id == sectionId,
          orElse: () => ref.watch(settingsSectionsProvider).first,
        );
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      children: [
        Text(section.label, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(
          section.subtitle,
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
      case 'engine':
        return const EngineSection();
      case 'privacy':
        return const PrivacySection();
      case 'about':
        return const AboutSection();
      case 'appearance':
      default:
        return const AppearanceSection();
    }
  }
}
