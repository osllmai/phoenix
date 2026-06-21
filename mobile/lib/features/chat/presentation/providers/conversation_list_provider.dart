import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:phoenix_core/phoenix_core.dart';

import 'chat_providers.dart';

part 'conversation_list_provider.g.dart';

/// All saved conversations for the list pane. Reference for the function-form
/// `@riverpod` provider pattern.
@riverpod
Future<List<Conversation>> conversationList(Ref ref) {
  return ref.watch(chatRepositoryProvider).conversations();
}
