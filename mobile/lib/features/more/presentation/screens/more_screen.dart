import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../more_menu.dart';

/// Phone-only hub for every destination that isn't on the bottom bar.
/// Curated to mirror `design/mock/mobile/more/m-more.html`.
class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  String _query = '';

  bool _matches(MoreEntry e) {
    final q = _query.trim().toLowerCase();
    return q.isEmpty ||
        e.title.toLowerCase().contains(q) ||
        e.subtitle.toLowerCase().contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sections = [
      for (final s in moreMenu)
        MoreSection(s.label, s.entries.where(_matches).toList()),
    ].where((s) => s.entries.isNotEmpty).toList();

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset('assets/phoenix.svg'),
        ),
        title: const Text('More'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, size: 20),
              hintText: 'Search…',
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          for (final s in sections) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 18, 4, 6),
              child: Text(
                s.label.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant, letterSpacing: 1.2),
              ),
            ),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [for (final e in s.entries) _row(context, e)],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(BuildContext context, MoreEntry e) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(e.icon),
      title: Text(e.title),
      subtitle:
          Text(e.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (e.onDevice)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: scheme.outlineVariant),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('on-device',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant)),
            ),
          const Icon(Icons.chevron_right, size: 18),
        ],
      ),
      onTap: () => context.go(e.path),
    );
  }
}
