import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/presentation/providers/settings_controller.dart';

const localeByLanguage = <String, Locale>{
  'English (US)': Locale('en'),
  'Français': Locale('fr'),
  'Deutsch': Locale('de'),
  '日本語': Locale('ja'),
};

final localeProvider = Provider<Locale>((ref) {
  final language = ref.watch(settingsControllerProvider).value?.language;
  return localeByLanguage[language] ?? const Locale('en');
});
