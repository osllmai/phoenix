import 'package:flutter/material.dart';

import '../data/flows_sample.dart';
import '../widgets/flows_pair_bar.dart';
import '../widgets/run_monitor_card.dart';
import '../widgets/saved_flows_card.dart';

class FlowsScreen extends StatelessWidget {
  const FlowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(),
            Divider(height: 1),
            FlowsPairBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 16),
                    RunMonitorCard(monitor: kRunningMonitor),
                    SizedBox(height: 16),
                    SavedFlowsCard(flows: kSavedFlows),
                    SizedBox(height: 16),
                    DesktopAuthoringNote(),
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
          const Icon(Icons.schema_outlined),
          const SizedBox(width: 8),
          Text('Developer · Flows',
              style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
