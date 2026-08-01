import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/radiant.dart';
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Settings'),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: const Drawer(child: SafeArea(child: SectionNav())),
        body: DecoratedBox(
          decoration: radiantBackdropDecoration(Theme.of(context).colorScheme),
          child: const SafeArea(child: MobileSettingsList()),
        ),
      );
    }

    final navWidth = ff.isDesktop ? 280.0 : 210.0;
    final active = ref.watch(
      settingsControllerProvider
          .select((s) => s.value?.activeSection ?? 'general'),
    );
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DecoratedBox(
        decoration: radiantBackdropDecoration(Theme.of(context).colorScheme),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(radiantGap),
            child: Row(
              children: [
                RadiantPanel(width: navWidth, child: const SectionNav()),
                const SizedBox(width: radiantGap),
                Expanded(
                  child: RadiantPanel(child: SectionDetail(sectionId: active)),
                ),
              ],
            ),
          ),
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
