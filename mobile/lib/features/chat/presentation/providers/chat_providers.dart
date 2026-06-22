import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:phoenix_core/phoenix_core.dart';

import '../../../models/presentation/providers/selection_providers.dart';

/// Chat persistence. Overridden in `main()` with [SqfliteChatRepository] once the
/// database is open; defaults to in-memory so widgets/tests work standalone.
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return InMemoryChatRepository();
});

/// The chat orchestrator, wiring the shared engine to the repository.
final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService(
    engine: ref.watch(activeEngineProvider),
    repository: ref.watch(chatRepositoryProvider),
  );
});
