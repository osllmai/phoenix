import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../providers/settings_controller.dart';
import '../widgets/mobile_settings_list.dart';
import '../widgets/section_detail.dart';
import '../widgets/section_nav.dart';

/// Settings surface. Two panes (section list + section detail) on tablet/desktop;
/// a single scrolling list of grouped tiles on phone, with the section list in a
/// Drawer for quick jumps.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ff = formFactorOf(context);
    final loading = ref.watch(
      settingsControllerProvider.select((s) => s.isLoading && !s.hasValue),
    );
    if (loading) return const _SettingsLoading();

    if (!ff.hasSidePane) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: const Drawer(child: SafeArea(child: SectionNav())),
        body: const SafeArea(child: MobileSettingsList()),
      );
    }

    final navWidth = ff.isDesktop ? 280.0 : 240.0;
    final active = ref.watch(
      settingsControllerProvider
          .select((s) => s.value?.activeSection ?? 'appearance'),
    );
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(width: navWidth, child: const SectionNav()),
            const VerticalDivider(width: 1),
            Expanded(child: SectionDetail(sectionId: active)),
          ],
        ),
      ),
    );
  }
}

class _SettingsLoading extends StatelessWidget {
  const _SettingsLoading();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}
