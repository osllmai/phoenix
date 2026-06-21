import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:phoenix/features/welcome/presentation/widgets/welcome_card.dart';
import 'package:phoenix/features/welcome/presentation/widgets/welcome_footer.dart';
import 'package:phoenix/features/welcome/presentation/widgets/welcome_step_indicator.dart';

Future<double> _cardWidthAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    const ProviderScope(
      child: MaterialApp(home: WelcomeScreen()),
    ),
  );
  await tester.pumpAndSettle();
  return tester.getSize(find.byType(WelcomeCard)).width;
}

void main() {
  testWidgets('wizard card, step rail and footer render on every form factor',
      (tester) async {
    for (final size in const [Size(400, 800), Size(800, 800), Size(1200, 800)]) {
      await _cardWidthAt(tester, size);
      expect(find.byType(WelcomeCard), findsOneWidget);
      expect(find.byType(WelcomeFooter), findsOneWidget);
      expect(find.byType(WelcomeStepIndicator), findsOneWidget);
      expect(find.text('Get started'), findsOneWidget);
    }
  });

  testWidgets('desktop card is wider than the phone card', (tester) async {
    final phone = await _cardWidthAt(tester, const Size(400, 800));
    final tablet = await _cardWidthAt(tester, const Size(800, 800));
    final desktop = await _cardWidthAt(tester, const Size(1200, 800));
    expect(tablet, greaterThan(phone));
    expect(desktop, greaterThan(tablet));
  });
}
