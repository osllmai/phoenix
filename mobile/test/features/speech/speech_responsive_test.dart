import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix/features/speech/presentation/screens/speech_screen.dart';
import 'package:phoenix/features/speech/presentation/widgets/speech_controls.dart';
import 'package:phoenix/features/speech/presentation/widgets/transcript_pane.dart';
import 'package:phoenix/features/speech/presentation/widgets/transcript_view.dart';
import 'package:phoenix/features/speech/presentation/widgets/transcription_list.dart';

Future<void> _pumpAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    const ProviderScope(
      child: MaterialApp(home: SpeechScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('phone: single column, no side pane, history hidden in drawer',
      (tester) async {
    await _pumpAt(tester, const Size(400, 900));
    expect(find.byType(TranscriptPane), findsOneWidget);
    expect(find.byType(SpeechControls), findsOneWidget);
    expect(find.byType(VerticalDivider), findsNothing);
    expect(find.byType(TranscriptionList), findsNothing);
  });

  testWidgets('tablet: controls + transcript split, no inline history',
      (tester) async {
    await _pumpAt(tester, const Size(800, 900));
    expect(find.byType(SpeechControls), findsOneWidget);
    expect(find.byType(TranscriptPane), findsOneWidget);
    expect(find.byType(TranscriptionList), findsNothing);
  });

  testWidgets('desktop: three panes including the history list', (tester) async {
    await _pumpAt(tester, const Size(1200, 900));
    expect(find.byType(SpeechControls), findsOneWidget);
    expect(find.byType(TranscriptPane), findsOneWidget);
    expect(find.byType(TranscriptionList), findsOneWidget);
  });

  testWidgets('tablet landscape 1280x800: empty state, no overflow',
      (tester) async {
    await _pumpAt(tester, const Size(1280, 800));
    expect(tester.takeException(), isNull);
    expect(find.byType(SpeechEmptyState), findsOneWidget);
    expect(find.text('No transcriptions yet'), findsOneWidget);
    expect(find.text('No past transcriptions'), findsOneWidget);
  });

  testWidgets('short 900x520: empty state renders without overflow',
      (tester) async {
    await _pumpAt(tester, const Size(900, 520));
    expect(tester.takeException(), isNull);
    expect(find.byType(SpeechEmptyState), findsOneWidget);
    expect(find.text('No transcriptions yet'), findsOneWidget);
  });
}
