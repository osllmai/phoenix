import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix/features/settings/presentation/data/settings_repository.dart';
import 'package:phoenix/features/settings/presentation/providers/settings_providers.dart';
import 'package:phoenix/features/settings/presentation/screens/settings_screen.dart';
import 'package:phoenix/features/settings/presentation/widgets/mobile_settings_list.dart';
import 'package:phoenix/features/settings/presentation/widgets/section_detail.dart';
import 'package:phoenix/features/settings/presentation/widgets/section_nav.dart';

Future<void> _pumpAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        settingsRepositoryProvider
            .overrideWithValue(InMemorySettingsRepository()),
      ],
      child: const MaterialApp(home: SettingsScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('phone: single scrolling list, no side pane', (tester) async {
    await _pumpAt(tester, const Size(400, 800));
    expect(find.byType(MobileSettingsList), findsOneWidget);
    expect(find.byType(VerticalDivider), findsNothing);
    expect(find.byType(SectionDetail), findsNothing);
  });

  for (final size in [const Size(800, 800), const Size(1200, 800)]) {
    testWidgets('width ${size.width.toInt()}: nav + detail two panes',
        (tester) async {
      await _pumpAt(tester, size);
      expect(find.byType(SectionNav), findsOneWidget);
      expect(find.byType(SectionDetail), findsOneWidget);
      expect(find.byType(VerticalDivider), findsOneWidget);
      expect(find.byType(MobileSettingsList), findsNothing);
    });
  }

  for (final size in [const Size(1280, 800), const Size(900, 520)]) {
    testWidgets(
        'no overflow at ${size.width.toInt()}x${size.height.toInt()}',
        (tester) async {
      await _pumpAt(tester, size);
      expect(tester.takeException(), isNull);
    });
  }
}
