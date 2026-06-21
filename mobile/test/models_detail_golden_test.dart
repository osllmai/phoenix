import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix/features/models/presentation/screens/model_detail_screen.dart';
import 'package:phoenix_core/phoenix_core.dart';

import 'models_test_support.dart';

void main() {
  setUpAll(loadFonts);

  testWidgets('model detail — idle', (t) async {
    await pump(
      t,
      InMemoryModelRepository(),
      const ModelDetailScreen(
        model: AiModel(
          id: 1,
          name: 'Llama-3.1-8B-Instruct',
          key: '/home/u/models/llama-3.1-8b-q4.gguf',
        ),
      ),
    );
    await expectLater(
      find.byType(ModelDetailScreen),
      matchesGoldenFile('goldens/models_detail.png'),
    );
  });
}
