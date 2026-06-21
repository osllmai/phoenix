import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/marketplace_controller.dart';

class ExtensionSearchBar extends ConsumerWidget {
  const ExtensionSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(marketplaceControllerProvider.notifier);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        onChanged: controller.search,
        decoration: const InputDecoration(
          isDense: true,
          prefixIcon: Icon(Icons.search),
          hintText: 'Search extensions…  (docling, whisper, langchain)',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
