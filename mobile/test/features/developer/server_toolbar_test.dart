import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix/features/developer/presentation/data/server_status_repository.dart';
import 'package:phoenix/features/developer/presentation/widgets/server_toolbar.dart';

import 'developer_test_support.dart';

Future<void> _pump(WidgetTester tester, ServerStatusRepository repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        serverStatusRepositoryProvider.overrideWithValue(repo),
      ],
      child: const MaterialApp(home: Scaffold(body: ServerToolbar())),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('reachable backend shows Running', (tester) async {
    await _pump(tester, reachableRepository());
    expect(find.text('Running'), findsOneWidget);
    expect(find.text('Unreachable'), findsNothing);
  });

  testWidgets('down backend shows Unreachable', (tester) async {
    await _pump(tester, unreachableRepository());
    expect(find.text('Unreachable'), findsOneWidget);
    expect(find.text('Running'), findsNothing);
  });

  testWidgets('refresh re-checks health', (tester) async {
    await _pump(tester, unreachableRepository());
    expect(find.text('Unreachable'), findsOneWidget);
    await tester.tap(find.text('Refresh'));
    await tester.pumpAndSettle();
    expect(find.text('Unreachable'), findsOneWidget);
  });
}
