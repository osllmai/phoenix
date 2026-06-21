// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All saved conversations for the list pane. Reference for the function-form
/// `@riverpod` provider pattern.

@ProviderFor(conversationList)
final conversationListProvider = ConversationListProvider._();

/// All saved conversations for the list pane. Reference for the function-form
/// `@riverpod` provider pattern.

final class ConversationListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Conversation>>,
          List<Conversation>,
          FutureOr<List<Conversation>>
        >
    with
        $FutureModifier<List<Conversation>>,
        $FutureProvider<List<Conversation>> {
  /// All saved conversations for the list pane. Reference for the function-form
  /// `@riverpod` provider pattern.
  ConversationListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversationListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversationListHash();

  @$internal
  @override
  $FutureProviderElement<List<Conversation>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Conversation>> create(Ref ref) {
    return conversationList(ref);
  }
}

String _$conversationListHash() => r'2bd6525022b29fd3d8da324d922193bc32afde57';
