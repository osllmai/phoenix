import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../features/command_palette/command_palette.dart';

/// The sidebar's top block: brand + collapse toggle, the "New" menu and the
/// search affordance. Collapses to icon-only with the rest of the sidebar.
class SidebarHeader extends StatelessWidget {
  const SidebarHeader({
    super.key,
    required this.collapsed,
    required this.onToggleCollapse,
    required this.onNavigate,
  });

  final bool collapsed;
  final VoidCallback onToggleCollapse;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 8),
          child: collapsed
              ? Center(
                  child: Tooltip(
                    message: 'Expand sidebar',
                    child: InkWell(
                      onTap: onToggleCollapse,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: SvgPicture.asset('assets/phoenix.svg',
                            width: 24, height: 24),
                      ),
                    ),
                  ),
                )
              : Row(children: [
                  SvgPicture.asset('assets/phoenix.svg', width: 24, height: 24),
                  const SizedBox(width: 8),
                  Text('Phoenix',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  IconButton(
                    onPressed: onToggleCollapse,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.chevron_left,
                        size: 18, color: scheme.onSurfaceVariant),
                  ),
                ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _NewButton(collapsed: collapsed, onNavigate: onNavigate),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: _SearchBar(collapsed: collapsed),
        ),
      ],
    );
  }
}

class _NewButton extends StatelessWidget {
  const _NewButton({required this.collapsed, required this.onNavigate});

  final bool collapsed;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, _) => FilledButton(
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(40),
          padding: EdgeInsets.symmetric(horizontal: collapsed ? 0 : 16),
        ),
        child: collapsed
            ? const Icon(Icons.add, size: 20)
            : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.add, size: 18),
                SizedBox(width: 6),
                Text('New'),
                Spacer(),
                Icon(Icons.arrow_drop_down, size: 18),
              ]),
      ),
      menuChildren: [
        for (final e in const [
          ('New chat', Icons.chat_bubble_outline, '/'),
          ('Add document', Icons.description_outlined, '/documents'),
          ('Download model', Icons.download_outlined, '/models/browse'),
          ('New flow', Icons.schema_outlined, '/developer/flows'),
        ])
          MenuItemButton(
            leadingIcon: Icon(e.$2, size: 18),
            onPressed: () => onNavigate(e.$3),
            child: Text(e.$1),
          ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.collapsed});

  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return OutlinedButton(
      onPressed: () => showCommandPalette(context),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(38),
        padding: EdgeInsets.symmetric(horizontal: collapsed ? 0 : 12),
        side: BorderSide(color: scheme.outline),
        foregroundColor: scheme.onSurfaceVariant,
      ),
      child: collapsed
          ? const Icon(Icons.search, size: 18)
          : Row(children: [
              const Icon(Icons.search, size: 18),
              const SizedBox(width: 8),
              const Text('Search…'),
              const Spacer(),
              Text('⌘K', style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12)),
            ]),
    );
  }
}
