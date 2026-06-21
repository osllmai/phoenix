import 'package:flutter/material.dart';

import 'active_model_hero.dart';
import 'document_library.dart';
import 'quick_actions.dart';
import 'recent_conversations.dart';
import 'server_status.dart';
import 'stat_cards.dart';
import 'system_resources.dart';
import 'tips_strip.dart';

class DashboardWide extends StatelessWidget {
  const DashboardWide({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const StatCards(columns: 3),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 7,
                child: Column(
                  children: [
                    ActiveModelHero(),
                    SizedBox(height: 16),
                    QuickActions(),
                    SizedBox(height: 16),
                    RecentConversations(),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                flex: 5,
                child: Column(
                  children: [
                    DocumentLibrary(),
                    SizedBox(height: 16),
                    ServerStatus(),
                    SizedBox(height: 16),
                    SystemResources(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const TipsStrip(),
        ],
      ),
    );
  }
}
