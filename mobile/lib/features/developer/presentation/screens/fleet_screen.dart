import 'package:flutter/material.dart';

import '../../../../app/radiant.dart';
import '../data/fleet_sample.dart';
import '../widgets/fleet_merge_banner.dart';
import '../widgets/fleet_prompt_sender.dart';
import '../widgets/fleet_run_card.dart';
import '../widgets/fleet_worktrees_card.dart';
import '../widgets/maestro_events_card.dart';
import '../widgets/maestro_pair_bar.dart';

/// Developer · Fleet — companion monitor for a fan-out run: one prompt raced
/// across agents in isolated worktrees on the paired desktop. The phone watches
/// lanes and approves the merge; it never spawns agents (platform split).
class FleetScreen extends StatelessWidget {
  const FleetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const data = fleetSample;
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
                  MaestroPairBar(pair: data.pair),
                  FleetPromptSender(
                    draft: data.promptDraft,
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
                          FleetRunCard(
                            title: data.runTitle,
                            meta: data.runMeta,
                          ),
                          const SizedBox(height: 16),
                          FleetWorktreesCard(
                            worktrees: data.worktrees,
                            summary: data.worktreesSummary,
                          ),
                          const SizedBox(height: 16),
                          FleetMergeBanner(merge: data.merge),
                          const SizedBox(height: 16),
                          MaestroEventsCard(events: data.events),
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
          const Icon(Icons.grid_view_outlined),
          const SizedBox(width: 8),
          Text(
            'Developer · Fleet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
