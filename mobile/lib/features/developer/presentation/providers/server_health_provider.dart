import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/server_health.dart';
import '../data/server_status_repository.dart';

part 'server_health_provider.g.dart';

/// Resolves to reachable/unreachable rather than erroring, so the UI has a single
/// data state to render (any failure → unreachable).
@riverpod
Future<ServerHealth> serverHealth(Ref ref) async {
  try {
    return await ref.watch(serverStatusRepositoryProvider).health();
  } catch (_) {
    return const ServerHealth.unreachable();
  }
}
