import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Stub data + view-state for the Providers screen. Hardcoded until the
/// IndoxHub / BYOK backend lands.

enum ProvidersView { success, add, empty, firstRun, loading, error, denied }

final providersViewProvider =
    StateProvider<ProvidersView>((ref) => ProvidersView.success);

enum ProvStatus { connected, disabled, notConnected, testFailed, denied }

enum KeyKind { byok, gateway, local, none }

enum DotTone { green, plum, blue, amber, accent, grey }

Color toneColor(DotTone tone, ColorScheme s) => switch (tone) {
      DotTone.green => const Color(0xFF6FCF97),
      DotTone.plum => s.tertiary,
      DotTone.blue => s.secondary,
      DotTone.amber => s.tertiaryContainer,
      DotTone.accent => s.primary,
      DotTone.grey => s.outline,
    };

@immutable
class ProviderEntry {
  const ProviderEntry({
    required this.name,
    required this.endpoint,
    required this.tone,
    required this.status,
    required this.keyKind,
    this.models = 0,
    this.maskedKey = '',
    this.errorMsg,
  });

  final String name;
  final String endpoint;
  final DotTone tone;
  final ProvStatus status;
  final KeyKind keyKind;
  final int models;
  final String maskedKey;
  final String? errorMsg;

  bool get enabled => status == ProvStatus.connected;
}

@immutable
class GatewayInfo {
  const GatewayInfo({
    required this.status,
    this.credits = r'$12.40',
    this.usedMonth = r'$6.22',
    this.usedPct = 0.34,
    this.maskedKey = 'idx-prod-••••2f7a',
    this.error,
  });

  final ProvStatus status;
  final String credits;
  final String usedMonth;
  final double usedPct;
  final String maskedKey;
  final String? error;
}

const gatewayConnected = GatewayInfo(status: ProvStatus.connected);

const gatewayError = GatewayInfo(
  status: ProvStatus.testFailed,
  error: 'Couldn\'t reach api.indoxhub.com — network error / request timed out. '
      'Check your connection or proxy, then retry. Connected providers are unaffected.',
);

const gatewayDenied = GatewayInfo(
  status: ProvStatus.denied,
  error: 'Your IndoxHub API key was rejected (401 Unauthorized) — invalid, '
      'revoked, or out of credits. Update the key or top up to restore access.',
);

const successProviders = [
  ProviderEntry(
      name: 'OpenAI',
      endpoint: 'api.openai.com/v1',
      tone: DotTone.green,
      status: ProvStatus.connected,
      keyKind: KeyKind.byok,
      models: 12,
      maskedKey: 'sk-••••••••3a9f'),
  ProviderEntry(
      name: 'Anthropic',
      endpoint: 'api.anthropic.com/v1',
      tone: DotTone.plum,
      status: ProvStatus.connected,
      keyKind: KeyKind.byok,
      models: 8,
      maskedKey: 'sk-ant-••••7fA'),
  ProviderEntry(
      name: 'Google · Gemini',
      endpoint: 'routed via IndoxHub',
      tone: DotTone.blue,
      status: ProvStatus.connected,
      keyKind: KeyKind.gateway,
      models: 5),
  ProviderEntry(
      name: 'Ollama',
      endpoint: 'http://localhost:24678/v1',
      tone: DotTone.green,
      status: ProvStatus.connected,
      keyKind: KeyKind.local,
      models: 7),
  ProviderEntry(
      name: 'Custom · OpenAI-compatible',
      endpoint: 'https://llm.internal.corp/v1',
      tone: DotTone.amber,
      status: ProvStatus.connected,
      keyKind: KeyKind.byok,
      models: 3,
      maskedKey: 'cust-••••••••b72c'),
  ProviderEntry(
      name: 'Mistral AI',
      endpoint: 'routed via IndoxHub',
      tone: DotTone.accent,
      status: ProvStatus.disabled,
      keyKind: KeyKind.gateway,
      models: 6),
  ProviderEntry(
      name: 'Together AI',
      endpoint: 'api.together.xyz/v1',
      tone: DotTone.grey,
      status: ProvStatus.notConnected,
      keyKind: KeyKind.none),
  ProviderEntry(
      name: 'Groq',
      endpoint: 'api.groq.com/openai/v1',
      tone: DotTone.grey,
      status: ProvStatus.notConnected,
      keyKind: KeyKind.none),
];

const errorProviders = [
  ProviderEntry(
      name: 'OpenAI',
      endpoint: 'api.openai.com/v1',
      tone: DotTone.green,
      status: ProvStatus.connected,
      keyKind: KeyKind.byok,
      models: 12,
      maskedKey: 'sk-••••••••3a9f'),
  ProviderEntry(
      name: 'Custom · OpenAI-compatible',
      endpoint: 'https://llm.internal.corp/v1',
      tone: DotTone.grey,
      status: ProvStatus.testFailed,
      keyKind: KeyKind.byok,
      errorMsg: 'Connection refused — endpoint unreachable.'),
  ProviderEntry(
      name: 'Groq',
      endpoint: 'api.groq.com/openai/v1',
      tone: DotTone.grey,
      status: ProvStatus.notConnected,
      keyKind: KeyKind.none),
];

const deniedProviders = [
  ProviderEntry(
      name: 'OpenAI',
      endpoint: 'api.openai.com/v1',
      tone: DotTone.green,
      status: ProvStatus.connected,
      keyKind: KeyKind.byok,
      models: 12,
      maskedKey: 'sk-••••••••3a9f'),
  ProviderEntry(
      name: 'Anthropic',
      endpoint: 'api.anthropic.com/v1',
      tone: DotTone.grey,
      status: ProvStatus.denied,
      keyKind: KeyKind.byok,
      maskedKey: 'sk-ant-••••7fA',
      errorMsg: 'Invalid API key (401) — rejected by Anthropic.'),
  ProviderEntry(
      name: 'Cohere',
      endpoint: 'api.cohere.com/v2',
      tone: DotTone.grey,
      status: ProvStatus.notConnected,
      keyKind: KeyKind.none),
];
