import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_sections.g.dart';

@immutable
class SettingsSection {
  const SettingsSection({
    required this.id,
    required this.label,
    required this.icon,
    required this.subtitle,
  });

  final String id;
  final String label;
  final IconData icon;
  final String subtitle;
}

@riverpod
List<SettingsSection> settingsSections(Ref ref) => const [
      SettingsSection(
        id: 'general',
        label: 'General',
        icon: Icons.tune_outlined,
        subtitle: 'Language, startup and default model.',
      ),
      SettingsSection(
        id: 'appearance',
        label: 'Appearance',
        icon: Icons.palette_outlined,
        subtitle: 'Theme, type scale and accent.',
      ),
      SettingsSection(
        id: 'engine',
        label: 'Engine & Params',
        icon: Icons.memory_outlined,
        subtitle: 'On-device inference via llama.cpp.',
      ),
      SettingsSection(
        id: 'privacy',
        label: 'Privacy & Data',
        icon: Icons.lock_outline,
        subtitle: 'Nothing leaves your device by default.',
      ),
      SettingsSection(
        id: 'storage',
        label: 'Storage',
        icon: Icons.storage_outlined,
        subtitle: 'Disk usage and local data.',
      ),
      SettingsSection(
        id: 'backend',
        label: 'Backend',
        icon: Icons.dns_outlined,
        subtitle: 'Storage engine and local HTTP gateway.',
      ),
      SettingsSection(
        id: 'about',
        label: 'About',
        icon: Icons.info_outline,
        subtitle: 'Build and runtime versions.',
      ),
    ];
