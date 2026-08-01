// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get sectionGeneral => 'Général';

  @override
  String get sectionGeneralSubtitle =>
      'Langue, démarrage et modèle par défaut.';

  @override
  String get sectionAppearance => 'Apparence';

  @override
  String get sectionAppearanceSubtitle =>
      'Thème, échelle typographique et accent.';

  @override
  String get sectionEngine => 'Moteur et paramètres';

  @override
  String get sectionEngineSubtitle =>
      'Inférence sur l\'appareil via llama.cpp.';

  @override
  String get sectionPrivacy => 'Confidentialité et données';

  @override
  String get sectionPrivacySubtitle =>
      'Rien ne quitte votre appareil par défaut.';

  @override
  String get sectionStorage => 'Stockage';

  @override
  String get sectionStorageSubtitle =>
      'Utilisation du disque et données locales.';

  @override
  String get sectionBackend => 'Backend';

  @override
  String get sectionBackendSubtitle =>
      'Moteur de stockage et passerelle HTTP locale.';

  @override
  String get sectionAbout => 'À propos';

  @override
  String get sectionAboutSubtitle => 'Versions de build et d\'exécution.';
}
