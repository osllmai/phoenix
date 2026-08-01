// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get sectionGeneral => 'General';

  @override
  String get sectionGeneralSubtitle => 'Language, startup and default model.';

  @override
  String get sectionAppearance => 'Appearance';

  @override
  String get sectionAppearanceSubtitle => 'Theme, type scale and accent.';

  @override
  String get sectionEngine => 'Engine & Params';

  @override
  String get sectionEngineSubtitle => 'On-device inference via llama.cpp.';

  @override
  String get sectionPrivacy => 'Privacy & Data';

  @override
  String get sectionPrivacySubtitle => 'Nothing leaves your device by default.';

  @override
  String get sectionStorage => 'Storage';

  @override
  String get sectionStorageSubtitle => 'Disk usage and local data.';

  @override
  String get sectionBackend => 'Backend';

  @override
  String get sectionBackendSubtitle => 'Storage engine and local HTTP gateway.';

  @override
  String get sectionAbout => 'About';

  @override
  String get sectionAboutSubtitle => 'Build and runtime versions.';
}
