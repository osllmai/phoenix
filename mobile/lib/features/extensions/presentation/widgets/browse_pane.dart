import 'package:flutter/material.dart';

import 'category_chips.dart';
import 'extension_search_bar.dart';
import 'marketplace_list.dart';
import 'shell_strip.dart';

class BrowsePane extends StatelessWidget {
  const BrowsePane({super.key, this.onMenu, this.onSelected});

  final VoidCallback? onMenu;
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
          child: Row(
            children: [
              if (onMenu != null)
                IconButton(onPressed: onMenu, icon: const Icon(Icons.menu)),
              const Text('🧩 '),
              Text('Extensions', style: text.titleMedium),
            ],
          ),
        ),
        const ShellStrip(),
        const ExtensionSearchBar(),
        SizedBox(height: 40, child: CategoryChips()),
        const SizedBox(height: 8),
        Expanded(child: MarketplaceList(onSelected: onSelected)),
      ],
    );
  }
}
