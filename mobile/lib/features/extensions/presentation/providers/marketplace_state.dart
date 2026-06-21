import 'package:freezed_annotation/freezed_annotation.dart';

part 'marketplace_state.freezed.dart';

@freezed
abstract class MarketplaceState with _$MarketplaceState {
  const factory MarketplaceState({
    String? selectedSlug,
    @Default(<String>{}) Set<String> installing,
  }) = _MarketplaceState;
}
