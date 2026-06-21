import 'package:flutter/material.dart';

import '../providers/deepsearch_state.dart';
import 'answer_pane.dart';
import 'follow_up.dart';
import 'research_plan.dart';

/// The left/primary research column: plan timeline, synthesized answer and
/// the follow-up affordance. Shared by every form factor.
class AnswerColumn extends StatelessWidget {
  const AnswerColumn({super.key, required this.state});

  final DeepSearchState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.steps.isNotEmpty) ...[
          ResearchPlan(steps: state.steps),
          const SizedBox(height: 20),
        ],
        AnswerPane(answer: state.answer, sourceCount: state.sources.length),
        const SizedBox(height: 20),
        const FollowUp(),
      ],
    );
  }
}
