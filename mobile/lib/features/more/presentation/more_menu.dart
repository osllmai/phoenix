import 'package:flutter/material.dart';

/// One destination row in the More hub.
class MoreEntry {
  const MoreEntry(this.icon, this.title, this.subtitle, this.path,
      {this.onDevice = false});

  final IconData icon;
  final String title;
  final String subtitle;
  final String path;
  final bool onDevice;
}

/// A titled group of [MoreEntry]s.
class MoreSection {
  const MoreSection(this.label, this.entries);

  final String label;
  final List<MoreEntry> entries;
}

/// The curated More menu — mirrors `design/mock/mobile/more/m-more.html`
/// (desktop-pairing connection states deferred until pairing ships).
const moreMenu = <MoreSection>[
  MoreSection('Knowledge', [
    MoreEntry(Icons.travel_explore_outlined, 'DeepSearch',
        'Iterative search across your sources', '/deepsearch',
        onDevice: true),
    MoreEntry(Icons.mic_none_outlined, 'Speech',
        'Voice in · spoken replies out', '/speech', onDevice: true),
  ]),
  MoreSection('Developer', [
    MoreEntry(Icons.dns_outlined, 'Server', 'Local gateway & agent terminal',
        '/developer'),
    MoreEntry(Icons.account_tree_outlined, 'Maestro',
        'Send goals · monitor the orchestra', '/developer/maestro'),
    MoreEntry(Icons.alt_route_outlined, 'Flows',
        'Wire and watch multi-step pipelines', '/developer/flows'),
    MoreEntry(Icons.balance_outlined, 'Evaluators',
        'Score and compare run outputs', '/developer/evaluators'),
  ]),
  MoreSection('Tools', [
    MoreEntry(Icons.show_chart_outlined, 'Forecasting',
        'TimesFM time-series forecasts', '/forecasting'),
  ]),
  MoreSection('System', [
    MoreEntry(Icons.extension_outlined, 'Extensions',
        'Add and manage feature modules', '/extensions'),
    MoreEntry(Icons.settings_outlined, 'Settings',
        'Models · pairing · appearance', '/settings', onDevice: true),
  ]),
];
