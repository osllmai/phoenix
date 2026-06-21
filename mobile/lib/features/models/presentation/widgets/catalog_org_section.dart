import 'package:flutter/material.dart';

import '../../data/catalog_entry.dart';
import 'catalog_entry_tile.dart';

class CatalogOrgSection extends StatelessWidget {
  const CatalogOrgSection({
    super.key,
    required this.org,
    required this.entries,
    required this.wide,
  });

  final String org;
  final List<CatalogEntry> entries;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(_label(org), style: text.titleMedium),
        ),
        for (final e in entries) CatalogEntryTile(entry: e, wide: wide),
      ],
    );
  }

  String _label(String org) =>
      org.isEmpty ? org : org[0].toUpperCase() + org.substring(1);
}
