import 'package:flutter/material.dart';

import '../../data/catalog_entry.dart';
import 'catalog_entry_tile.dart';

class BrowseResults extends StatelessWidget {
  const BrowseResults({super.key, required this.entries, required this.wide});

  final List<CatalogEntry> entries;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Center(child: Text('No matches.'));
    }
    return ListView.builder(
      itemCount: entries.length,
      itemExtent: null,
      itemBuilder: (context, i) =>
          CatalogEntryTile(entry: entries[i], wide: wide),
    );
  }
}
