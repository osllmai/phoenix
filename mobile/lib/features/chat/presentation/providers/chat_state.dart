import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:phoenix_core/phoenix_core.dart';

part 'chat_state.freezed.dart';

/// UI state for the active chat session. Reference for the freezed model pattern
/// every feature follows.
@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    @Default(<Message>[]) List<Message> messages,
    @Default('') String streaming,
    @Default(false) bool isGenerating,
    int? selectedId,
  }) = _ChatState;
}
