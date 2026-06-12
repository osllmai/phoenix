#!/usr/bin/env bash
# Phoenix test runner: the pure-Dart core package + the Flutter app's widget tests.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "▶ phoenix_core (pure Dart)"
( cd ../packages/phoenix_core && dart pub get >/dev/null && dart test )

echo "▶ mobile widget tests"
flutter test test/widget_test.dart test/feature_registry_test.dart

echo "✓ all tests passed"
