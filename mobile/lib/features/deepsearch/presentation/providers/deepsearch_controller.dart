import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/deepsearch_mapper.dart';
import '../data/deepsearch_repository.dart';
import 'deepsearch_state.dart';

part 'deepsearch_controller.g.dart';

const _pollInterval = Duration(seconds: 1);
const _maxPolls = 120;

/// Drives a research session against the live backend: POSTs the query, then
/// polls the run until it is `ready` or `failed`, exposing idle/searching/
/// ready/error via [AsyncValue].
@riverpod
class DeepSearchController extends _$DeepSearchController {
  @override
  Future<DeepSearchState> build() async => const DeepSearchState();

  DeepSearchState get _current => state.value ?? const DeepSearchState();

  Future<void> run(String query) async {
    final q = query.trim();
    if (q.isEmpty) return;
    final scope = _current.localScope ? 'local' : 'web';
    final depth = depthToApi(_current.depth);

    state = AsyncData(_current.copyWith(query: q, isRunning: true, hasResult: false));
    state = await AsyncValue.guard(() async {
      final repo = ref.read(deepSearchRepositoryProvider);
      final id = await repo.startSearch(q, scope, depth);
      return _poll(id);
    });
  }

  Future<DeepSearchState> _poll(int id) async {
    final repo = ref.read(deepSearchRepositoryProvider);
    for (var i = 0; i < _maxPolls; i++) {
      final run = await repo.getRun(id);
      if (run.status == 'failed') {
        throw Exception(run.error.isEmpty ? 'Search failed' : run.error);
      }
      if (run.status == 'ready') return stateFromDetail(run);
      await Future<void>.delayed(_pollInterval);
    }
    throw Exception('Search timed out');
  }

  void setQuery(String query) =>
      state = AsyncData(_current.copyWith(query: query));

  void toggleWeb() =>
      state = AsyncData(_current.copyWith(webScope: !_current.webScope));

  void toggleLocal() =>
      state = AsyncData(_current.copyWith(localScope: !_current.localScope));

  void setDepth(SearchDepth depth) =>
      state = AsyncData(_current.copyWith(depth: depth));
}
