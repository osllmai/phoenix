import 'package:flutter/material.dart';

import '../../../../app/radiant.dart';
import '../data/evaluators_sample.dart';
import '../widgets/scorecard_card.dart';

class EvaluatorsScreen extends StatelessWidget {
  const EvaluatorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const data = evaluatorsSample;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RadiantBackdrop(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(radiantGap),
            child: RadiantPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Header(),
                  const Divider(height: 1),
                  _ViewOnlyBar(statusLabel: data.statusLabel),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final scorecard in data.scorecards) ...[
                            const SizedBox(height: 16),
                            ScorecardCard(scorecard: scorecard),
                          ],
                          const SizedBox(height: 16),
                          _DesktopNote(text: data.desktopNote),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.bar_chart_outlined),
          const SizedBox(width: 8),
          Text('Developer · Evaluators',
              style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _ViewOnlyBar extends StatelessWidget {
  const _ViewOnlyBar({required this.statusLabel});

  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      color: scheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: scheme.tertiary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              statusLabel,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopNote extends StatelessWidget {
  const _DesktopNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.desktop_windows_outlined,
              size: 18, color: scheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
