import 'package:flutter/material.dart';

import 'active_model_hero.dart';
import 'document_library.dart';
import 'quick_actions.dart';
import 'recent_conversations.dart';
import 'server_status.dart';
import 'stat_cards.dart';
import 'system_resources.dart';
import 'tips_strip.dart';

class DashboardStacked extends StatelessWidget {
  const DashboardStacked({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      children: const [
        StatCards(columns: 1),
        SizedBox(height: 16),
        ActiveModelHero(),
        SizedBox(height: 16),
        QuickActions(stacked: true),
        SizedBox(height: 16),
        RecentConversations(),
        SizedBox(height: 16),
        DocumentLibrary(),
        SizedBox(height: 16),
        ServerStatus(),
        SizedBox(height: 16),
        SystemResources(),
        SizedBox(height: 16),
        TipsStrip(stacked: true),
      ],
    );
  }
}
