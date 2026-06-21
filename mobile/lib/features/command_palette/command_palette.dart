import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'palette_entries.dart';

/// Opens the global quick-switcher (⌘K). Searches pages, models, conversations
/// and documents; selecting a result navigates to it.
Future<void> showCommandPalette(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black54,
    builder: (_) => const CommandPalette(),
  );
}

class CommandPalette extends ConsumerStatefulWidget {
  const CommandPalette({super.key});

  @override
  ConsumerState<CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends ConsumerState<CommandPalette> {
  String _query = '';

  void _run(PaletteEntry entry) {
    Navigator.of(context).pop();
    entry.onSelect();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final entries = buildPaletteEntries(context, ref, _query);

    return Dialog(
      alignment: Alignment.topCenter,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Jump to a page, model, chat or document…',
                  border: InputBorder.none,
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: entries.isEmpty
                  ? Center(
                      child: Text('No matches',
                          style: TextStyle(color: scheme.onSurfaceVariant)))
                  : ListView(children: _grouped(entries, scheme)),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _grouped(List<PaletteEntry> entries, ColorScheme scheme) {
    final widgets = <Widget>[];
    for (final section in PaletteSection.values) {
      final group = entries.where((e) => e.section == section);
      if (group.isEmpty) continue;
      widgets.add(Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Text(section.label.toUpperCase(),
            style: TextStyle(
                fontSize: 11,
                letterSpacing: 1.1,
                color: scheme.onSurfaceVariant)),
      ));
      for (final e in group) {
        widgets.add(ListTile(
          dense: true,
          leading: Icon(e.icon, size: 20),
          title: Text(e.label, maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: () => _run(e),
        ));
      }
    }
    return widgets;
  }
}
