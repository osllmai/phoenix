import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/extension_entry.dart';
import '../providers/marketplace_controller.dart';
import 'extension_detail_head.dart';

class ExtensionDetail extends ConsumerWidget {
  const ExtensionDetail({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(selectedExtensionProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    if (entry == null) {
      return Center(
        child: Text('Select an extension',
            style: text.titleMedium?.copyWith(color: scheme.onSurfaceVariant)),
      );
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ExtensionDetailHead(entry: entry, onBack: onBack),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 130,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: scheme.outline),
                ),
                child: Text('Screenshot — ${entry.name}',
                    style: text.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant)),
              ),
              const SizedBox(height: 16),
              Text(entry.description, style: text.bodyMedium),
              const SizedBox(height: 16),
              Text('Requirements', style: text.titleSmall),
              const SizedBox(height: 8),
              _Req(k: 'Install size', v: entry.size),
              _Req(k: 'Category', v: entry.category.label),
              const _Req(k: 'Runs', v: 'On-device · no data leaves the machine'),
            ],
          ),
        ),
      ],
    );
  }
}

class _Req extends StatelessWidget {
  const _Req({required this.k, required this.v});
  final String k;
  final String v;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(k,
                style:
                    text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
          ),
          Expanded(child: Text(v, style: text.bodySmall)),
        ],
      ),
    );
  }
}
