import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'convos_collapsed_provider.g.dart';

const _kCollapsed = 'phoenix.chat.convosCollapsed';

/// Whether the conversation column is collapsed to the narrow rail. `null` means
/// the user has not chosen, so the side-pane falls back to its form-factor
/// default (tablet collapses, desktop expands). Persisted across reloads.
@Riverpod(keepAlive: true)
class ConvosCollapsed extends _$ConvosCollapsed {
  @override
  Future<bool?> build() async {
    try {
      return await SharedPreferencesAsync().getBool(_kCollapsed);
    } catch (_) {
      return null;
    }
  }

  Future<void> set(bool value) async {
    state = AsyncData(value);
    try {
      await SharedPreferencesAsync().setBool(_kCollapsed, value);
    } catch (_) {}
  }

  Future<void> toggle(bool current) => set(!current);
}
