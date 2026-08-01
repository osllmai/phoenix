import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/radiant.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../providers/deepsearch_controller.dart';
import '../providers/deepsearch_state.dart';
import '../widgets/answer_column.dart';
import '../widgets/first_run_view.dart';
import '../widgets/query_header.dart';
import '../widgets/sources_pane.dart';

/// The DeepSearch surface. Results (answer/plan) and sources sit in two panes
/// side by side on tablet/desktop; phone stacks them in one scrolling column.
class DeepSearchScreen extends ConsumerWidget {
  const DeepSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ff = formFactorOf(context);
    final async = ref.watch(deepSearchControllerProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RadiantBackdrop(
        child: SafeArea(
          child: Column(
            children: [
              QueryHeader(onMenu: ff.isPhone ? () {} : null),
              const Divider(height: 1),
              Expanded(
                child: switch (async) {
                  AsyncLoading() => const _Busy(),
                  AsyncError(:final error) => _Failed(message: '$error'),
                  AsyncData(:final value) when !value.hasResult =>
                    const FirstRunView(),
                  AsyncData(:final value) => ff.hasSidePane
                      ? _TwoPane(state: value, isDesktop: ff.isDesktop)
                      : _SingleColumn(state: value),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Busy extends StatelessWidget {
  const _Busy();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Researching…'),
        ],
      ),
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: scheme.error, size: 40),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _TwoPane extends StatelessWidget {
  const _TwoPane({required this.state, required this.isDesktop});

  final DeepSearchState state;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final sourcesWidth = isDesktop ? 380.0 : 320.0;
    return Padding(
      padding: const EdgeInsets.all(radiantGap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: RadiantPanel(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: AnswerColumn(state: state),
              ),
            ),
          ),
          const SizedBox(width: radiantGap),
          RadiantPanel(
            width: sourcesWidth,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: SourcesPane(sources: state.sources),
            ),
          ),
        ],
      ),
    );
  }
}

class _SingleColumn extends StatelessWidget {
  const _SingleColumn({required this.state});

  final DeepSearchState state;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnswerColumn(state: state),
          const SizedBox(height: 20),
          SourcesPane(sources: state.sources),
        ],
      ),
    );
  }
}
