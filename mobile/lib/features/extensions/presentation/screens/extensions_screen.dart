import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../widgets/browse_pane.dart';
import '../widgets/extension_detail.dart';

/// The Extensions marketplace. A browse list + detail pane side by side on
/// tablet/desktop; a single-column list that pushes a detail page on phone.
class ExtensionsScreen extends ConsumerWidget {
  const ExtensionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ff = formFactorOf(context);

    if (!ff.hasSidePane) {
      return Scaffold(
        body: SafeArea(
          child: BrowsePane(
            onSelected: () => _openDetail(context),
          ),
        ),
      );
    }

    final listWidth = ff.isDesktop ? 420.0 : 340.0;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(width: listWidth, child: const BrowsePane()),
            const VerticalDivider(width: 1),
            const Expanded(child: ExtensionDetail()),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          body: SafeArea(
            child: ExtensionDetail(onBack: () => Navigator.of(context).pop()),
          ),
        ),
      ),
    );
  }
}
