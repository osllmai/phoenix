import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/radiant.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../providers/convos_collapsed_provider.dart';
import '../widgets/conversation_list.dart';
import '../widgets/conversation_pane.dart';
import '../widgets/conversation_rail.dart';

/// The chat surface. Two panes (conversation list + active conversation) on
/// tablet/desktop; a single pane with the list in a Drawer on phone.
class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ff = formFactorOf(context);

    if (!ff.hasSidePane) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        drawer: const Drawer(child: SafeArea(child: ConversationList())),
        body: RadiantBackdrop(
          child: SafeArea(
            child: Builder(
              builder: (context) => ConversationPane(
                onMenu: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
        ),
      );
    }

    final savedPref = ref.watch(convosCollapsedProvider).value;
    final collapsed = savedPref ?? ff.isTablet;
    final collapser = ref.read(convosCollapsedProvider.notifier);

    final listWidth = ff.isDesktop ? 300.0 : 240.0;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RadiantBackdrop(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(radiantGap),
            child: Row(
              children: [
                if (collapsed)
                  RadiantPanel(
                    child: ConversationRail(onExpand: () => collapser.set(false)),
                  )
                else
                  RadiantPanel(
                    width: listWidth,
                    child: ConversationList(
                      onCollapse: () => collapser.set(true),
                    ),
                  ),
                const SizedBox(width: radiantGap),
                const Expanded(child: RadiantPanel(child: ConversationPane())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
