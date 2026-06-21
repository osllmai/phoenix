import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/online_catalog_stub.dart';
import '../providers/online_state_provider.dart';
import '../widgets/online/cloud_notice.dart';
import '../widgets/online/online_header.dart';
import '../widgets/online/online_states.dart';
import '../widgets/online/online_success.dart';
import '../widgets/online/online_toolbar.dart';

/// Models › Online · IndoxHub — hosted (cloud) models routed via the IndoxHub
/// gateway. Stubbed catalog until the backend lands; states drive the view.
class OnlineModelsScreen extends ConsumerStatefulWidget {
  const OnlineModelsScreen({super.key});

  @override
  ConsumerState<OnlineModelsScreen> createState() => _OnlineModelsScreenState();
}

class _OnlineModelsScreenState extends ConsumerState<OnlineModelsScreen> {
  String _provider = 'openai';
  String _query = '';
  String _filter = 'All';
  String _default = 'openai/gpt-4o';
  bool _byok = false;
  final Set<String> _selected = {'openai/gpt-4o'};

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onlineStateProvider);
    return Scaffold(
      body: Column(
        children: [
          OnlineHeader(
            state: state,
            onState: (s) =>
                ref.read(onlineStateProvider.notifier).state = s,
          ),
          if (state == OnlineState.success) ...[
            const CloudNotice(),
            OnlineToolbar(
              active: _filter,
              onFilter: (f) => setState(() => _filter = f),
              onSearch: (q) => setState(() => _query = q),
            ),
          ],
          if (state == OnlineState.loading)
            const CloudNotice(
                text: 'Connecting to the IndoxHub gateway and fetching the '
                    'model catalog…'),
          Expanded(child: _body(state)),
        ],
      ),
    );
  }

  Widget _body(OnlineState state) => switch (state) {
        OnlineState.success => OnlineSuccess(
            providerId: _provider,
            query: _query,
            filter: _filter,
            selected: _selected,
            defaultId: _default,
            byok: _byok,
            onProvider: (p) => setState(() => _provider = p),
            onToggle: (id, on) => setState(
                () => on ? _selected.add(id) : _selected.remove(id)),
            onDefault: (id) => setState(() => _default = id),
            onByok: (v) => setState(() => _byok = v),
            onClear: () => setState(_selected.clear),
          ),
        OnlineState.empty => const OnlineCenterState(
            emoji: '🔭',
            title: 'No models match',
            body: 'No hosted models match your search and filters. Clear them, '
                'or pick another provider.'),
        OnlineState.firstRun => const ConnectIndoxHubForm(),
        OnlineState.loading => const OnlineLoading(),
        OnlineState.error => const OnlineCenterState(
            emoji: '⚡',
            title: 'Router unreachable',
            body: 'Check your connection or the IndoxHub status, then retry.',
            errorBox: 'Could not reach IndoxHub.\n'
                'ETIMEDOUT connecting to api.indoxhub.com:443'),
        OnlineState.denied => const OnlineCenterState(
            emoji: '🔒',
            title: 'API key invalid or unauthorized',
            body: "The catalog can't load until a valid key is configured.",
            errorBox: '401 Unauthorized — your IndoxHub API key is missing, '
                'invalid, or revoked.'),
      };
}
