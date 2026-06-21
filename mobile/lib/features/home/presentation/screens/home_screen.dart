import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_stacked.dart';
import '../widgets/dashboard_wide.dart';

/// The dashboard / overview surface. A two-column card grid with a full-width
/// tips strip on tablet/desktop; a single stacked column on phone.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ff = formFactorOf(context);
    final wide = ff.hasSidePane;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DashboardHeader(compact: !wide),
            const Divider(height: 1),
            Expanded(
              child: wide ? const DashboardWide() : const DashboardStacked(),
            ),
          ],
        ),
      ),
    );
  }
}
