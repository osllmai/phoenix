import 'package:flutter/material.dart';

import '../../../data/providers_stub.dart';
import 'gateway_card.dart';
import 'privacy_note.dart';
import 'provider_card.dart';

/// The populated Providers body: privacy note, the IndoxHub gateway card, and
/// the list of provider key cards. Reused for the error/denied variants by
/// passing a different [gateway] + [providers].
class ProvidersSuccess extends StatelessWidget {
  const ProvidersSuccess({
    super.key,
    required this.gateway,
    required this.providers,
    this.countLabel = '5 connected · 3 available',
  });

  final GatewayInfo gateway;
  final List<ProviderEntry> providers;
  final String countLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const PrivacyNote(),
        const SizedBox(height: 20),
        GatewayCard(info: gateway),
        const SizedBox(height: 20),
        Row(
          children: [
            Text('Provider keys',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Text(countLabel,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: scheme.onSurfaceVariant)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final p in providers) ...[
          ProviderCard(p: p),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
