import '../core/feature/feature_module.dart';
import '../features/chat/chat_module.dart';
import '../features/models/models_module.dart';

/// The composition root: the ordered set of features the app loads.
///
/// THIS is the one place to add/remove a feature. Adding a feature = add its
/// module here (and create the module). The router and nav update automatically.
/// As the app grows, gate entries behind flags here rather than editing the shell.
const List<FeatureModule> phoenixFeatures = [
  ChatModule(),
  ModelsModule(),
  // documents (Docling) · deepsearch · developer · speech · settings → add here
];
