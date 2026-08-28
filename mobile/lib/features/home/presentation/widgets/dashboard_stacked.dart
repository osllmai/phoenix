import 'package:flutter/material.dart';

import 'active_model_hero.dart';
import 'document_library.dart';
import 'quick_actions.dart';
import 'recent_conversations.dart';
import 'server_status.dart';
import 'stat_cards.dart';
import 'system_resources.dart';
import 'tips_strip.dart';

/// One column of cards. [compact] is the phone dressing — one stat per row and
/// stacked action tiles; a tablet has the width to keep those side by side.
class DashboardStacked extends StatelessWidget {
  const DashboardStacked({super.key, this.compact = true});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      children: [
        StatCards(columns: compact ? 1 : 3),
        const SizedBox(height: 16),
        const ActiveModelHero(),
        const SizedBox(height: 16),
        QuickActions(stacked: compact),
        const SizedBox(height: 16),
        const RecentConversations(),
        const SizedBox(height: 16),
        const DocumentLibrary(),
        const SizedBox(height: 16),
        const ServerStatus(),
        const SizedBox(height: 16),
        const SystemResources(),
        const SizedBox(height: 16),
        TipsStrip(stacked: compact),
      ],
    );
  }
}
