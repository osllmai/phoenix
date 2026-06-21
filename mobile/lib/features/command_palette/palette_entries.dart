import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phoenix_core/phoenix_core.dart';

import '../../core/feature/feature_registry.dart';
import '../chat/presentation/providers/chat_controller.dart';
import '../chat/presentation/providers/conversation_list_provider.dart';
import '../documents/presentation/providers/document.dart';
import '../documents/presentation/providers/documents_providers.dart';
import '../models/presentation/providers/model_providers.dart';

/// The four kinds of thing the command palette can jump to.
enum PaletteSection { pages, models, conversations, documents }

extension PaletteSectionLabel on PaletteSection {
  String get label => switch (this) {
        PaletteSection.pages => 'Pages',
        PaletteSection.models => 'Models',
        PaletteSection.conversations => 'Conversations',
        PaletteSection.documents => 'Documents',
      };
}

/// One selectable row in the palette. [onSelect] captures a persistent router /
/// notifier reference so it survives the palette dialog being dismissed.
class PaletteEntry {
  const PaletteEntry({
    required this.section,
    required this.label,
    required this.icon,
    required this.onSelect,
  });

  final PaletteSection section;
  final String label;
  final IconData icon;
  final VoidCallback onSelect;
}

/// Aggregates pages + installed models + conversations + documents into a single
/// filtered list. Data that needs a backend simply contributes nothing offline.
List<PaletteEntry> buildPaletteEntries(
  BuildContext context,
  WidgetRef ref,
  String query,
) {
  final router = GoRouter.of(context);
  final chat = ref.read(chatControllerProvider.notifier);
  final docSel = ref.read(selectedDocumentIdProvider.notifier);
  final q = query.trim().toLowerCase();
  bool hit(String s) => q.isEmpty || s.toLowerCase().contains(q);

  final out = <PaletteEntry>[];

  for (final n in ref.watch(featureRegistryProvider).navItems()) {
    if (hit(n.label)) {
      out.add(PaletteEntry(
        section: PaletteSection.pages,
        label: n.label,
        icon: n.icon,
        onSelect: () => router.go(n.path),
      ));
    }
  }

  for (final m in ref.watch(modelsControllerProvider).value ?? const <AiModel>[]) {
    if (hit(m.name)) {
      out.add(PaletteEntry(
        section: PaletteSection.models,
        label: m.name,
        icon: Icons.memory_outlined,
        onSelect: () => router.push('/models/detail', extra: m),
      ));
    }
  }

  for (final c in ref.watch(conversationListProvider).value ?? const <Conversation>[]) {
    if (hit(c.title)) {
      out.add(PaletteEntry(
        section: PaletteSection.conversations,
        label: c.title,
        icon: Icons.chat_bubble_outline,
        onSelect: () {
          chat.open(c);
          router.go('/');
        },
      ));
    }
  }

  for (final d in ref.watch(documentLibraryProvider).value ?? const <PhoenixDocument>[]) {
    if (hit(d.title)) {
      out.add(PaletteEntry(
        section: PaletteSection.documents,
        label: d.title,
        icon: Icons.description_outlined,
        onSelect: () {
          docSel.select(d.id);
          router.go('/documents');
        },
      ));
    }
  }

  return out;
}
