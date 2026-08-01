import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/radiant.dart';
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
        backgroundColor: Colors.transparent,
        body: RadiantBackdrop(
          child: SafeArea(
            child: BrowsePane(
              onSelected: () => _openDetail(context),
            ),
          ),
        ),
      );
    }

    final listWidth = ff.isDesktop ? 420.0 : 340.0;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RadiantBackdrop(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(radiantGap),
            child: Row(
              children: [
                RadiantPanel(width: listWidth, child: const BrowsePane()),
                const SizedBox(width: radiantGap),
                const Expanded(child: RadiantPanel(child: ExtensionDetail())),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          backgroundColor: Colors.transparent,
          body: RadiantBackdrop(
            child: SafeArea(
              child: ExtensionDetail(onBack: () => Navigator.of(context).pop()),
            ),
          ),
        ),
      ),
    );
  }
}
