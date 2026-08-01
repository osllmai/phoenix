// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get sectionGeneral => '一般';

  @override
  String get sectionGeneralSubtitle => '言語、起動、既定のモデル。';

  @override
  String get sectionAppearance => '外観';

  @override
  String get sectionAppearanceSubtitle => 'テーマ、文字サイズ、アクセント。';

  @override
  String get sectionEngine => 'エンジンとパラメータ';

  @override
  String get sectionEngineSubtitle => 'llama.cpp によるデバイス上の推論。';

  @override
  String get sectionPrivacy => 'プライバシーとデータ';

  @override
  String get sectionPrivacySubtitle => '既定では何もデバイスの外に出ません。';

  @override
  String get sectionStorage => 'ストレージ';

  @override
  String get sectionStorageSubtitle => 'ディスク使用量とローカルデータ。';

  @override
  String get sectionBackend => 'バックエンド';

  @override
  String get sectionBackendSubtitle => 'ストレージエンジンとローカル HTTP ゲートウェイ。';

  @override
  String get sectionAbout => '情報';

  @override
  String get sectionAboutSubtitle => 'ビルドとランタイムのバージョン。';
}
