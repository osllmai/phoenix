import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Loads root monorepo `.env` from disk (never as a Flutter asset — that would
/// ship server secrets into the client bundle).
Future<void> loadPhoenixEnv() async {
  final override = Platform.environment['PHOENIX_ENV_FILE'];
  final candidates = <File>[
    if (override != null && override.isNotEmpty) File(override),
    File('.env'),
    File('../.env'),
  ];
  for (final file in candidates) {
    if (await file.exists()) {
      dotenv.loadFromString(envString: await file.readAsString());
      return;
    }
  }
}

String phoenixEnv(String key, {String fromDefine = ''}) {
  final fromFile = dotenv.maybeGet(key);
  if (fromFile != null && fromFile.isNotEmpty) return fromFile;
  if (fromDefine.isNotEmpty) return fromDefine;
  throw StateError('$key missing — set in root .env or --dart-define');
}

String get apiBaseUrl => phoenixEnv(
      'PHOENIX_API_BASE_URL',
      fromDefine: const String.fromEnvironment('PHOENIX_API_BASE_URL'),
    );

String get hfApi => phoenixEnv(
      'PHOENIX_HF_API',
      fromDefine: const String.fromEnvironment('PHOENIX_HF_API'),
    );

String get catalogUrl => phoenixEnv(
      'PHOENIX_CATALOG_URL',
      fromDefine: const String.fromEnvironment('PHOENIX_CATALOG_URL'),
    );

String get gatewayPort => phoenixEnv(
      'PHOENIX_GATEWAY_PORT',
      fromDefine: const String.fromEnvironment('PHOENIX_GATEWAY_PORT'),
    );

String get gatewayLabel => 'On-device · :$gatewayPort';

String get gatewayHostPort => 'localhost:$gatewayPort';
