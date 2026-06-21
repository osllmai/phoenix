import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Golden harness for the whole suite: loads the app font so goldens render
/// real text, then runs every test under the default Alchemist config.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final loader = FontLoader('DMSans')
    ..addFont(rootBundle.load('assets/fonts/DMSans-Regular.ttf'));
  await loader.load();
  return AlchemistConfig.runWithConfig(
    config: const AlchemistConfig(),
    run: testMain,
  );
}
