import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/radiant.dart';
import '../../data/catalog_entry.dart';
import '../widgets/catalog_entry_action.dart';
import '../widgets/hf_files_list.dart';
import '../widgets/runnability_badge.dart';

String? _repoIdFrom(CatalogEntry e) {
  final link = e.hfLink;
  const marker = 'huggingface.co/';
  final i = link.indexOf(marker);
  if (i < 0) return null;
  final tail = link.substring(i + marker.length).split('?').first;
  final parts = tail.split('/').where((p) => p.isNotEmpty).toList();
  if (parts.length < 2) return null;
  return '${parts[0]}/${parts[1]}';
}

class ModelCatalogDetailScreen extends ConsumerWidget {
  const ModelCatalogDetailScreen({super.key, required this.entry});

  final CatalogEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repoId = _repoIdFrom(entry);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(entry.name.isEmpty ? entry.modelName : entry.name),
        leading: const BackButton(),
      ),
      body: RadiantBackdrop(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: RunnabilityBadge(entry: entry),
            ),
            const SizedBox(height: 12),
            _InfoCard(entry: entry),
            const SizedBox(height: 24),
            if (entry.url.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: CatalogEntryAction(entry: entry),
              )
            else if (repoId != null)
              HfFilesList(repoId: repoId)
            else
              const Text('No downloadable file available for this model.'),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.entry});

  final CatalogEntry entry;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[
      ('Organization', entry.org),
      ('Capability', entry.capability),
      ('Type', entry.type),
      if (entry.filesizeGb > 0)
        ('Size', '${entry.filesizeGb.toStringAsFixed(2)} GB'),
      ('Quant', entry.quant),
      if (entry.ramRequired > 0) ('RAM required', '${entry.ramRequired} GB'),
      ('GPU required', entry.gpuRequired ? 'Yes' : 'No'),
      ('License', entry.license),
      if (entry.downloadCount > 0) ('Downloads', '${entry.downloadCount}'),
      if (entry.likeCount > 0) ('Likes', '${entry.likeCount}'),
      ('Hugging Face', entry.hfLink),
    ].where((r) => r.$2.isNotEmpty).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [for (final r in rows) _InfoRow(label: r.$1, value: r.$2)],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
