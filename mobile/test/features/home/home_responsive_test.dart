import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix/core/ai/engine_provider.dart';
import 'package:phoenix/features/chat/presentation/providers/conversation_list_provider.dart';
import 'package:phoenix/features/home/presentation/screens/home_screen.dart';
import 'package:phoenix/features/home/presentation/widgets/dashboard_stacked.dart';
import 'package:phoenix/features/home/presentation/widgets/dashboard_wide.dart';
import 'package:phoenix/features/models/presentation/providers/model_providers.dart';
import 'package:phoenix_core/phoenix_core.dart';

import 'home_test_data.dart';

class _FakeEngine implements InferencePort {
  @override
  EngineState get state => EngineState.ready;
  @override
  Future<void> loadModel(String modelPath) async {}
  @override
  Stream<String> prompt(String p, {InferenceParams params = const InferenceParams()}) =>
      const Stream.empty();
  @override
  Future<void> stop() async {}
  @override
  Future<void> dispose() async {}
}

Future<void> _pumpAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        inferenceEngineProvider.overrideWithValue(_FakeEngine()),
        modelRepositoryProvider.overrideWithValue(seededModelRepository()),
        activeModelProvider.overrideWithValue(kActiveModel),
        conversationListProvider.overrideWith((ref) async => kConversations),
      ],
      child: const MaterialApp(home: HomeScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('phone: single stacked column, no two-column grid', (tester) async {
    await _pumpAt(tester, const Size(400, 800));
    expect(find.byType(DashboardStacked), findsOneWidget);
    expect(find.byType(DashboardWide), findsNothing);
  });

  // The two-column 7/5 split needs desktop width; at tablet width the side
  // column is ~330px and its card headers ellipsize (seen on the S7).
  testWidgets('tablet: one column, tablet-dressed not phone-dressed',
      (tester) async {
    await _pumpAt(tester, const Size(800, 800));
    expect(find.byType(DashboardStacked), findsOneWidget);
    expect(find.byType(DashboardWide), findsNothing);
    expect(
      tester.widget<DashboardStacked>(find.byType(DashboardStacked)).compact,
      isFalse,
    );
  });

  testWidgets('phone: stacked column is phone-dressed', (tester) async {
    await _pumpAt(tester, const Size(400, 800));
    expect(
      tester.widget<DashboardStacked>(find.byType(DashboardStacked)).compact,
      isTrue,
    );
  });

  testWidgets('desktop: two-column wide grid', (tester) async {
    await _pumpAt(tester, const Size(1200, 800));
    expect(find.byType(DashboardWide), findsOneWidget);
    expect(find.byType(DashboardStacked), findsNothing);
  });

  testWidgets('renders the real installed-model count and conversation titles',
      (tester) async {
    await _pumpAt(tester, const Size(1200, 800));
    expect(find.text('${kModels.length}'), findsWidgets);
    expect(find.text(kConversations.first.title), findsOneWidget);
  });
}
