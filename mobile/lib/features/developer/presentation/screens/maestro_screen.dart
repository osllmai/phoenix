import 'package:flutter/material.dart';

import '../data/maestro_sample.dart';
import '../widgets/maestro_agents_card.dart';
import '../widgets/maestro_approval_banner.dart';
import '../widgets/maestro_events_card.dart';
import '../widgets/maestro_goal_card.dart';
import '../widgets/maestro_goal_sender.dart';
import '../widgets/maestro_pair_bar.dart';
import '../widgets/maestro_plan_timeline.dart';

class MaestroScreen extends StatelessWidget {
  const MaestroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const data = maestroSample;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Header(),
            const Divider(height: 1),
            MaestroPairBar(pair: data.pair),
            MaestroGoalSender(
              draft: data.goalDraft,
              presets: data.presets,
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    MaestroGoalCard(goal: data.goal),
                    const SizedBox(height: 16),
                    MaestroPlanTimeline(steps: data.plan),
                    const SizedBox(height: 16),
                    MaestroApprovalBanner(approval: data.approval),
                    const SizedBox(height: 16),
                    MaestroAgentsCard(agents: data.agents),
                    const SizedBox(height: 16),
                    MaestroEventsCard(events: data.events),
                  ],
                ),
              ),
            ),
          ],
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
          const Icon(Icons.account_tree_outlined),
          const SizedBox(width: 8),
          Text(
            'Developer · Maestro',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
