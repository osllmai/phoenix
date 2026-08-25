import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/radiant.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_stacked.dart';
import '../widgets/dashboard_wide.dart';

/// The dashboard / overview surface. A two-column card grid with a full-width
/// tips strip on desktop; a single stacked column on phone and tablet, where
/// the 7/5 split leaves the side column too narrow for its card headers.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ff = formFactorOf(context);
    final panelled = ff.hasSidePane;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DashboardHeader(compact: !panelled),
        const Divider(height: 1),
        Expanded(
          child: ff.isDesktop
              ? const DashboardWide()
              : DashboardStacked(compact: ff.isPhone),
        ),
      ],
    );

    if (!panelled) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: RadiantBackdrop(child: SafeArea(child: content)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RadiantBackdrop(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(radiantGap),
            child: RadiantPanel(child: content),
          ),
        ),
      ),
    );
  }
}
