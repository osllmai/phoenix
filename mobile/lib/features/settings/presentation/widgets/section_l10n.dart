import '../../../../l10n/app_localizations.dart';

String sectionLabel(AppLocalizations l10n, String id) {
  switch (id) {
    case 'general':
      return l10n.sectionGeneral;
    case 'appearance':
      return l10n.sectionAppearance;
    case 'engine':
      return l10n.sectionEngine;
    case 'privacy':
      return l10n.sectionPrivacy;
    case 'storage':
      return l10n.sectionStorage;
    case 'backend':
      return l10n.sectionBackend;
    case 'about':
      return l10n.sectionAbout;
    default:
      return id;
  }
}

String sectionSubtitle(AppLocalizations l10n, String id) {
  switch (id) {
    case 'general':
      return l10n.sectionGeneralSubtitle;
    case 'appearance':
      return l10n.sectionAppearanceSubtitle;
    case 'engine':
      return l10n.sectionEngineSubtitle;
    case 'privacy':
      return l10n.sectionPrivacySubtitle;
    case 'storage':
      return l10n.sectionStorageSubtitle;
    case 'backend':
      return l10n.sectionBackendSubtitle;
    case 'about':
      return l10n.sectionAboutSubtitle;
    default:
      return '';
  }
}
