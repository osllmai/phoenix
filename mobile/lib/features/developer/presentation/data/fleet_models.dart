import 'maestro_models.dart';

export 'maestro_models.dart' show MaestroPair, MaestroEvent, MaestroPreset;

enum FleetWorktreeState { running, done, blocked }

class FleetWorktree {
  const FleetWorktree({
    required this.name,
    required this.path,
    required this.statusLabel,
    required this.state,
    required this.summary,
    required this.meta,
    this.diffstat,
    this.routeDenied = false,
    this.leads = false,
    this.canViewDiff = false,
  });

  final String name;
  final String path;
  final String statusLabel;
  final FleetWorktreeState state;
  final List<String> summary;
  final String meta;
  final String? diffstat;
  final bool routeDenied;
  final bool leads;
  final bool canViewDiff;
}

class FleetMerge {
  const FleetMerge({
    required this.winner,
    required this.summary,
    required this.badge,
    required this.branches,
  });

  final String winner;
  final String summary;
  final String badge;
  final List<String> branches;
}

class FleetData {
  const FleetData({
    required this.pair,
    required this.promptDraft,
    required this.presets,
    required this.runTitle,
    required this.runMeta,
    required this.worktreesSummary,
    required this.worktrees,
    required this.merge,
    required this.events,
  });

  final MaestroPair pair;
  final String promptDraft;
  final List<MaestroPreset> presets;
  final String runTitle;
  final String runMeta;
  final String worktreesSummary;
  final List<FleetWorktree> worktrees;
  final FleetMerge merge;
  final List<MaestroEvent> events;
}
