enum MaestroStepState { done, running, gated, pending }

enum MaestroAgentState { done, running, queued, idle }

class MaestroPair {
  const MaestroPair({required this.label, required this.host});

  final String label;
  final String host;
}

class MaestroGoal {
  const MaestroGoal({
    required this.text,
    required this.pattern,
    required this.flow,
    required this.conductor,
  });

  final String text;
  final String pattern;
  final String flow;
  final String conductor;
}

class MaestroStep {
  const MaestroStep({
    required this.title,
    required this.meta,
    required this.statusLabel,
    required this.state,
  });

  final String title;
  final String meta;
  final String statusLabel;
  final MaestroStepState state;
}

class MaestroApproval {
  const MaestroApproval({required this.title, required this.detail});

  final String title;
  final String detail;
}

class MaestroAgent {
  const MaestroAgent({
    required this.name,
    required this.role,
    required this.statusLabel,
    required this.state,
    required this.lines,
  });

  final String name;
  final String role;
  final String statusLabel;
  final MaestroAgentState state;
  final List<String> lines;
}

class MaestroEvent {
  const MaestroEvent({
    required this.time,
    required this.actor,
    required this.text,
    this.outcome,
  });

  final String time;
  final String actor;
  final String text;
  final String? outcome;
}

class MaestroPreset {
  const MaestroPreset({required this.label});

  final String label;
}

class MaestroData {
  const MaestroData({
    required this.pair,
    required this.goalDraft,
    required this.presets,
    required this.goal,
    required this.plan,
    required this.approval,
    required this.agents,
    required this.events,
  });

  final MaestroPair pair;
  final String goalDraft;
  final List<MaestroPreset> presets;
  final MaestroGoal goal;
  final List<MaestroStep> plan;
  final MaestroApproval approval;
  final List<MaestroAgent> agents;
  final List<MaestroEvent> events;
}
