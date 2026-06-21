import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../widgets/conversation_list.dart';
import '../widgets/conversation_pane.dart';

/// The chat surface. Two panes (conversation list + active conversation) on
/// tablet/desktop; a single pane with the list in a Drawer on phone.
class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ff = formFactorOf(context);

    if (!ff.hasSidePane) {
      return Scaffold(
        drawer: const Drawer(child: SafeArea(child: ConversationList())),
        body: SafeArea(
          child: Builder(
            builder: (context) => ConversationPane(
              onMenu: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
      );
    }

    final listWidth = ff.isDesktop ? 300.0 : 240.0;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(width: listWidth, child: const ConversationList()),
            const VerticalDivider(width: 1),
            const Expanded(child: ConversationPane()),
          ],
        ),
      ),
    );
  }
}
