import 'package:flutter/material.dart';

import '../../../data/online_catalog_stub.dart';
import 'online_model_card.dart';
import 'online_success_parts.dart';
import 'provider_rail.dart';

/// The Online success view: provider rail + a model-card grid grouped by
/// provider section, with a BYOK row and a multi-select action bar.
class OnlineSuccess extends StatelessWidget {
  const OnlineSuccess({
    super.key,
    required this.providerId,
    required this.query,
    required this.filter,
    required this.selected,
    required this.defaultId,
    required this.byok,
    required this.onProvider,
    required this.onToggle,
    required this.onDefault,
    required this.onByok,
    required this.onClear,
  });

  final String providerId;
  final String query;
  final String filter;
  final Set<String> selected;
  final String defaultId;
  final bool byok;
  final ValueChanged<String> onProvider;
  final void Function(String id, bool on) onToggle;
  final ValueChanged<String> onDefault;
  final ValueChanged<bool> onByok;
  final VoidCallback onClear;

  bool _matches(OnlineModel m) {
    if (providerId != 'all' && m.providerId != providerId) return false;
    final q = query.toLowerCase();
    if (q.isNotEmpty &&
        !m.name.toLowerCase().contains(q) &&
        !m.id.toLowerCase().contains(q)) {
      return false;
    }
    return switch (filter) {
      'Recommended' => m.recBadge != null,
      'Vision' => m.vision,
      'Tools' => m.tools,
      'Long context' => m.ctx.contains('M') || m.ctx == '200k',
      _ => true,
    };
  }

  @override
  Widget build(BuildContext context) {
    final visible = onlineModels.where(_matches).toList();
    return Row(
      children: [
        ProviderRail(selectedId: providerId, onSelect: onProvider),
        Expanded(
          child: Column(
            children: [
              if (selected.isNotEmpty) _selBar(context),
              Expanded(
                child: visible.isEmpty
                    ? _noMatch(context)
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: _sections(visible),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _sections(List<OnlineModel> visible) {
    final out = <Widget>[];
    for (final (name, tag) in onlineSections) {
      final models = visible.where((m) => m.section == name).toList();
      if (models.isEmpty) continue;
      out.add(SectionHead(name: name, tag: tag));
      if (name == 'OpenAI') out.add(ByokRow(value: byok, onChanged: onByok));
      out.add(const SizedBox(height: 8));
      out.add(_grid(models));
      out.add(const SizedBox(height: 16));
    }
    return out;
  }

  Widget _grid(List<OnlineModel> models) => LayoutBuilder(
        builder: (context, c) {
          final cols = c.maxWidth > 560 ? 2 : 1;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final m in models)
                SizedBox(
                  width: (c.maxWidth - (cols - 1) * 12) / cols,
                  child: OnlineModelCard(
                    model: m,
                    selected: selected.contains(m.id),
                    isDefault: defaultId == m.id,
                    onToggle: (v) => onToggle(m.id, v),
                    onSetDefault: () => onDefault(m.id),
                  ),
                ),
            ],
          );
        },
      );

  Widget _selBar(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(bottom: BorderSide(color: scheme.primary, width: 2)),
      ),
      child: Row(children: [
        Text('${selected.length} selected',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        const Spacer(),
        FilledButton(
            onPressed: () {},
            child: Text('Add ${selected.length} '
                'model${selected.length == 1 ? '' : 's'}')),
        const SizedBox(width: 8),
        OutlinedButton(onPressed: onClear, child: const Text('Clear')),
      ]),
    );
  }

  Widget _noMatch(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('🔭', style: TextStyle(fontSize: 40)),
        const SizedBox(height: 8),
        Text('No models match',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text('Clear your search or filters, or pick another provider.',
            style: TextStyle(color: scheme.onSurfaceVariant)),
      ]),
    );
  }
}
