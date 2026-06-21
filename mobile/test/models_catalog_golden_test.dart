import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix/features/models/presentation/providers/model_providers.dart';
import 'package:phoenix/features/models/presentation/screens/add_model_screen.dart';
import 'package:phoenix/features/models/presentation/screens/models_screen.dart';
import 'package:phoenix/features/models/presentation/widgets/drop_import.dart';
import 'package:phoenix_core/phoenix_core.dart';

import 'models_test_support.dart';

void main() {
  setUpAll(loadFonts);

  testWidgets('catalog — empty', (t) async {
    await pump(t, InMemoryModelRepository(), const ModelsScreen());
    await expectLater(
      find.byType(ModelsScreen),
      matchesGoldenFile('goldens/models_empty.png'),
    );
  });

  testWidgets('catalog — populated', (t) async {
    await pump(t, await seeded(), const ModelsScreen());
    await expectLater(
      find.byType(ModelsScreen),
      matchesGoldenFile('goldens/models_populated.png'),
    );
  });

  testWidgets('add model — form', (t) async {
    await pump(t, InMemoryModelRepository(), const AddModelScreen());
    await expectLater(
      find.byType(AddModelScreen),
      matchesGoldenFile('goldens/models_add.png'),
    );
  });

  testWidgets('catalog — favorites filter', (t) async {
    await pump(
      t,
      await seeded(),
      const ModelsScreen(),
      extra: [modelFavOnlyProvider.overrideWith(FavOnlyOn.new)],
    );
    await expectLater(
      find.byType(ModelsScreen),
      matchesGoldenFile('goldens/models_filtered.png'),
    );
  });

  testWidgets('catalog — drag-and-drop overlay', (t) async {
    await pump(
      t,
      await seeded(),
      const Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Positioned.fill(child: ModelsScreen()),
            Positioned.fill(child: DropHint()),
          ],
        ),
      ),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/models_drop.png'),
    );
  });

  testWidgets('catalog — remove shows Undo snackbar', (t) async {
    await pump(t, await seeded(), const ModelsScreen());
    await t.tap(find.byTooltip('Remove').first);
    await t.pumpAndSettle();
    await t.tap(find.widgetWithText(FilledButton, 'Remove'));
    await t.pumpAndSettle();
    await expectLater(
      find.byType(ModelsScreen),
      matchesGoldenFile('goldens/models_snackbar.png'),
    );
  });
}
