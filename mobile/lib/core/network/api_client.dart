import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Base URL of the local Phoenix backend. Compile-time configurable via
/// `--dart-define=PHOENIX_API_BASE_URL`; defaults to the local docker backend.
const apiBaseUrl = String.fromEnvironment(
  'PHOENIX_API_BASE_URL',
  defaultValue: 'http://localhost:37000/api/v1',
);

/// The shared HTTP client every feature's API repository depends on. Override in
/// tests with a Dio backed by a mock adapter; never construct Dio per-feature.
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );
});
