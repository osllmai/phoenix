import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../widgets/speech_controls.dart';
import '../widgets/transcript_pane.dart';
import '../widgets/transcription_list.dart';

/// Whisper speech-to-text surface. Controls + transcript split with a history
/// side pane on desktop; controls + transcript stacked with a history drawer on
/// phone.
class SpeechScreen extends ConsumerWidget {
  const SpeechScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ff = formFactorOf(context);

    if (!ff.hasSidePane) {
      return Scaffold(
        drawer: const Drawer(child: SafeArea(child: TranscriptionList())),
        body: SafeArea(
          child: Builder(
            builder: (context) => Column(
              children: [
                Expanded(
                  child: TranscriptPane(
                    onMenu: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                const Divider(height: 1),
                const SizedBox(
                  height: 320,
                  child: SpeechControls(),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final controlsWidth = ff.isDesktop ? 340.0 : 300.0;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(width: controlsWidth, child: const SpeechControls()),
            const VerticalDivider(width: 1),
            const Expanded(child: TranscriptPane()),
            if (ff.isDesktop) ...[
              const VerticalDivider(width: 1),
              const SizedBox(width: 300, child: TranscriptionList()),
            ],
          ],
        ),
      ),
    );
  }
}
