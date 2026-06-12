#!/usr/bin/env bash
# Phoenix mobile test runner.
#
# Two runners by necessity:
#   • dart test     — pure-Dart unit/integration (engine spawns a subprocess via
#                     the Dart VM; needs the real `dart` executable, not
#                     flutter_tester).
#   • flutter test  — widget tests (need the Flutter binding).
set -euo pipefail
cd "$(dirname "$0")/.."

echo "▶ pure-Dart tests"
dart test \
  test/subprocess_engine_test.dart \
  test/chat_service_test.dart \
  test/chat_repository_db_test.dart \
  test/model_manager_test.dart

echo "▶ Flutter widget tests"
flutter test test/widget_test.dart

echo "✓ all mobile tests passed"
