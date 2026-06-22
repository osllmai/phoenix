import 'package:flutter/material.dart';

enum FlowRunOutcome { passed, gated, failed }

enum FlowStepStatus { done, running, pending, gateWaiting, failed }

@immutable
class FlowStep {
  const FlowStep({
    required this.title,
    required this.kind,
    required this.status,
    this.subtitle,
  });

  final String title;
  final String kind;
  final FlowStepStatus status;
  final String? subtitle;
}

@immutable
class RunMonitor {
  const RunMonitor({
    required this.flowName,
    required this.statusLabel,
    required this.steps,
    required this.gatePrompt,
  });

  final String flowName;
  final String statusLabel;
  final List<FlowStep> steps;
  final String gatePrompt;
}

@immutable
class SavedFlow {
  const SavedFlow({
    required this.icon,
    required this.title,
    required this.shape,
    required this.lastRun,
    required this.outcome,
  });

  final String icon;
  final String title;
  final String shape;
  final String lastRun;
  final FlowRunOutcome outcome;
}

const RunMonitor kRunningMonitor = RunMonitor(
  flowName: 'research → draft → review → publish',
  statusLabel: 'step 4 of 5',
  gatePrompt:
      'This gate passed (0.86). Approve to publish, or send back to redraft.',
  steps: [
    FlowStep(
      title: 'Manual trigger',
      kind: 'trigger',
      status: FlowStepStatus.done,
      subtitle: 'fired from phone · 00:00',
    ),
    FlowStep(
      title: 'phoenix-search',
      kind: 'tool',
      status: FlowStepStatus.done,
      subtitle: 'DeepSearch · 8 sources',
    ),
    FlowStep(
      title: 'claude-code: draft',
      kind: 'agent',
      status: FlowStepStatus.done,
      subtitle: 'local gateway · 70B · 1,240 tok',
    ),
    FlowStep(
      title: 'Ragas: faithful?',
      kind: 'eval · gate',
      status: FlowStepStatus.gateWaiting,
      subtitle: 'score 0.86 ≥ 0.8 · awaiting your approval',
    ),
    FlowStep(
      title: 'Write file',
      kind: 'output',
      status: FlowStepStatus.pending,
      subtitle: 'draft.md',
    ),
  ],
);

const List<SavedFlow> kSavedFlows = [
  SavedFlow(
    icon: '🔬',
    title: 'research → draft → review → publish',
    shape: '[trigger]→[search]→[draft]→[Ragas?]→[write]',
    lastRun: 'Last run 2h ago',
    outcome: FlowRunOutcome.passed,
  ),
  SavedFlow(
    icon: '🔁',
    title: 'PR review · fan-out',
    shape: '[file-drop]→[claude+codex]→[merge]→[diff]',
    lastRun: 'Last run yesterday',
    outcome: FlowRunOutcome.gated,
  ),
  SavedFlow(
    icon: '📄',
    title: 'doc Q&A · grounded answer',
    shape: '[trigger]→[phoenix-doc]→[answer]→[Ragas?]',
    lastRun: 'Last run Jun 9',
    outcome: FlowRunOutcome.passed,
  ),
  SavedFlow(
    icon: '🧪',
    title: 'test-gen · loop until green',
    shape: '[trigger]→[codex:tests]→[shell:run]→[branch↻]',
    lastRun: 'Last run Jun 7',
    outcome: FlowRunOutcome.failed,
  ),
];
