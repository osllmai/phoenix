// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives a chat session: appends the user message, streams the model response
/// into a live bubble, then commits it. Reference for the `@riverpod` Notifier
/// pattern every feature controller follows.

@ProviderFor(ChatController)
final chatControllerProvider = ChatControllerProvider._();

/// Drives a chat session: appends the user message, streams the model response
/// into a live bubble, then commits it. Reference for the `@riverpod` Notifier
/// pattern every feature controller follows.
final class ChatControllerProvider
    extends $NotifierProvider<ChatController, ChatState> {
  /// Drives a chat session: appends the user message, streams the model response
  /// into a live bubble, then commits it. Reference for the `@riverpod` Notifier
  /// pattern every feature controller follows.
  ChatControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatControllerHash();

  @$internal
  @override
  ChatController create() => ChatController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatState>(value),
    );
  }
}

String _$chatControllerHash() => r'395a173f06aef1e125afcac8f28fa65ce2dc501c';

/// Drives a chat session: appends the user message, streams the model response
/// into a live bubble, then commits it. Reference for the `@riverpod` Notifier
/// pattern every feature controller follows.

abstract class _$ChatController extends $Notifier<ChatState> {
  ChatState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ChatState, ChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatState, ChatState>,
              ChatState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
