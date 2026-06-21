import 'package:flutter/material.dart';

/// Static onboarding copy. Hardcoded English for now — the app has no gen-l10n
/// setup yet; move these to ARB keys when localization lands.

@immutable
class WelcomeFeature {
  const WelcomeFeature(this.icon, this.title, this.body);
  final IconData icon;
  final String title;
  final String body;
}

@immutable
class OnboardingModel {
  const OnboardingModel({
    required this.id,
    required this.icon,
    required this.name,
    required this.tagline,
    required this.size,
    required this.quant,
  });
  final String id;
  final IconData icon;
  final String name;
  final String tagline;
  final String size;
  final String quant;
}

@immutable
class PrivacyPoint {
  const PrivacyPoint(this.icon, this.title, this.body);
  final IconData icon;
  final String title;
  final String body;
}

const welcomeFeatures = [
  WelcomeFeature(Icons.psychology_outlined, 'On-device inference',
      'Local models via llama.cpp — no cloud, no API keys.'),
  WelcomeFeature(Icons.description_outlined, 'Multi-format documents',
      'PDF, Office, images & audio → clean markdown via Docling.'),
  WelcomeFeature(Icons.dns_outlined, 'Local API server',
      'OpenAI- & Anthropic-compatible endpoints on localhost.'),
  WelcomeFeature(Icons.lock_outline, 'Full privacy',
      'Chats stored locally in SQLite. Offline-first.'),
];

const privacyPoints = [
  PrivacyPoint(Icons.lock_outline, 'Inference runs entirely on-device',
      'Your prompts and files never leave your computer.'),
  PrivacyPoint(Icons.wifi_off_outlined, 'No network required',
      'Chat, search, and generate without an internet connection.'),
  PrivacyPoint(Icons.storage_outlined, 'Conversations stored locally',
      'Everything is kept in an on-device SQLite database — no cloud sync.'),
];

const readyChips = [
  'On-device inference',
  'Documents via Docling',
  'Local API server',
  'No telemetry',
];

const modelSources = [
  (Icons.folder_outlined, 'Add a local .gguf file'),
  (Icons.cloud_download_outlined, 'Browse the Hugging Face Hub'),
  (Icons.language_outlined, 'Connect online via IndoxHub'),
];
