import 'package:freezed_annotation/freezed_annotation.dart';

part 'deepsearch_state.freezed.dart';

enum ResearchStepStatus { done, active, pending }

enum SearchDepth { quick, standard, deep }

@freezed
abstract class ResearchStep with _$ResearchStep {
  const factory ResearchStep({
    required String label,
    required String detail,
    required ResearchStepStatus status,
  }) = _ResearchStep;
}

@freezed
abstract class SearchSource with _$SearchSource {
  const factory SearchSource({
    required int rank,
    required String title,
    required String domain,
    required String snippet,
    required int relevance,
    @Default(false) bool isLocal,
  }) = _SearchSource;
}

@freezed
abstract class DeepSearchState with _$DeepSearchState {
  const factory DeepSearchState({
    @Default('') String query,
    @Default(<ResearchStep>[]) List<ResearchStep> steps,
    @Default('') String answer,
    @Default(<SearchSource>[]) List<SearchSource> sources,
    @Default(true) bool webScope,
    @Default(true) bool localScope,
    @Default(SearchDepth.standard) SearchDepth depth,
    @Default(false) bool isRunning,
    @Default(false) bool hasResult,
  }) = _DeepSearchState;
}
