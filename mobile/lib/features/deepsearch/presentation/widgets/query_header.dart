import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/deepsearch_controller.dart';
import '../providers/deepsearch_state.dart';

class QueryHeader extends ConsumerStatefulWidget {
  const QueryHeader({super.key, this.onMenu});

  final VoidCallback? onMenu;

  @override
  ConsumerState<QueryHeader> createState() => _QueryHeaderState();
}

class _QueryHeaderState extends ConsumerState<QueryHeader> {
  late final TextEditingController _input;

  @override
  void initState() {
    super.initState();
    final state = ref.read(deepSearchControllerProvider).value;
    _input = TextEditingController(text: state?.query ?? '');
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _run() =>
      ref.read(deepSearchControllerProvider.notifier).run(_input.text);

  @override
  Widget build(BuildContext context) {
    final state =
        ref.watch(deepSearchControllerProvider).value ??
            const DeepSearchState();
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.surfaceContainerLow,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (widget.onMenu != null)
                IconButton(onPressed: widget.onMenu, icon: const Icon(Icons.menu)),
              Expanded(
                child: TextField(
                  controller: _input,
                  onSubmitted: (_) => _run(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Ask a research question…',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(onPressed: _run, child: const Text('Run')),
            ],
          ),
          const SizedBox(height: 8),
          _ScopeRow(state: state),
        ],
      ),
    );
  }
}

class _ScopeRow extends ConsumerWidget {
  const _ScopeRow({required this.state});

  final DeepSearchState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.read(deepSearchControllerProvider.notifier);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const Text('Scope'),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('🌐 Web'),
            selected: state.webScope,
            onSelected: (_) => n.toggleWeb(),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('📄 Local docs'),
            selected: state.localScope,
            onSelected: (_) => n.toggleLocal(),
          ),
          const SizedBox(width: 12),
          SegmentedButton<SearchDepth>(
            segments: const [
              ButtonSegment(value: SearchDepth.quick, label: Text('Quick')),
              ButtonSegment(value: SearchDepth.standard, label: Text('Standard')),
              ButtonSegment(value: SearchDepth.deep, label: Text('Deep')),
            ],
            selected: {state.depth},
            showSelectedIcon: false,
            onSelectionChanged: (s) => n.setDepth(s.first),
          ),
        ],
      ),
    );
  }
}
