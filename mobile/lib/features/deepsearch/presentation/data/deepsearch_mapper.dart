import '../providers/deepsearch_state.dart';
import 'deepsearch_dto.dart';

SearchDepth depthFromApi(String depth) => switch (depth) {
      'quick' => SearchDepth.quick,
      'deep' => SearchDepth.deep,
      _ => SearchDepth.standard,
    };

String depthToApi(SearchDepth depth) => switch (depth) {
      SearchDepth.quick => 'quick',
      SearchDepth.deep => 'deep',
      SearchDepth.standard => 'standard',
    };

SearchSource sourceFromDto(SearchSourceDto dto, int rank) => SearchSource(
      rank: rank,
      title: dto.title,
      domain: 'Local document · #${dto.documentId}',
      snippet: dto.snippet,
      relevance: (dto.relevance * 100).round(),
      isLocal: true,
    );

DeepSearchState stateFromDetail(SearchDetailDto dto) {
  final sources = [
    for (var i = 0; i < dto.sources.length; i++)
      sourceFromDto(dto.sources[i], i + 1),
  ];
  return DeepSearchState(
    query: dto.query,
    answer: dto.answer,
    sources: sources,
    depth: depthFromApi(dto.depth),
    localScope: dto.scope == 'local',
    webScope: dto.scope == 'web',
    hasResult: dto.status == 'ready',
    isRunning: dto.status == 'pending' || dto.status == 'running',
  );
}
