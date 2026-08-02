// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get sectionGeneral => 'Allgemein';

  @override
  String get sectionGeneralSubtitle => 'Sprache, Start und Standardmodell.';

  @override
  String get sectionAppearance => 'Darstellung';

  @override
  String get sectionAppearanceSubtitle => 'Design, Schriftgröße und Akzent.';

  @override
  String get sectionEngine => 'Engine & Parameter';

  @override
  String get sectionEngineSubtitle => 'Inferenz auf dem Gerät über llama.cpp.';

  @override
  String get sectionPrivacy => 'Datenschutz & Daten';

  @override
  String get sectionPrivacySubtitle =>
      'Standardmäßig verlässt nichts Ihr Gerät.';

  @override
  String get sectionStorage => 'Speicher';

  @override
  String get sectionStorageSubtitle => 'Speichernutzung und lokale Daten.';

  @override
  String get sectionBackend => 'Backend';

  @override
  String get sectionBackendSubtitle =>
      'Speicher-Engine und lokales HTTP-Gateway.';

  @override
  String get sectionAbout => 'Über';

  @override
  String get sectionAboutSubtitle => 'Build- und Laufzeitversionen.';
}
