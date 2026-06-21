import '../core/feature/feature_module.dart';
import '../features/chat/chat_module.dart';
import '../features/deepsearch/deepsearch_module.dart';
import '../features/developer/developer_module.dart';
import '../features/documents/documents_module.dart';
import '../features/extensions/extensions_module.dart';
import '../features/forecasting/forecasting_module.dart';
import '../features/home/home_module.dart';
import '../features/models/models_module.dart';
import '../features/settings/settings_module.dart';
import '../features/speech/speech_module.dart';
import '../features/welcome/welcome_module.dart';

/// The composition root: the ordered set of features the app loads.
///
/// THIS is the one place to add/remove a feature. Adding a feature = add its
/// module here (and create the module). The router and nav update automatically.
/// As the app grows, gate entries behind flags here rather than editing the shell.
const List<FeatureModule> phoenixFeatures = [
  HomeModule(),
  ChatModule(),
  DeepSearchModule(),
  DocumentsModule(),
  ModelsModule(),
  SpeechModule(),
  ForecastingModule(),
  ExtensionsModule(),
  DeveloperModule(),
  SettingsModule(),
  WelcomeModule(),
];
