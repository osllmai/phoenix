/// Phoenix on-device LLM core (pure Dart).
///
/// Public SDK surface: the [PhoenixCore] facade plus the engine, service, and
/// entity types a host (Flutter UI, HTTP gateway, CLI) needs.
library;

// Facade
export 'src/phoenix_core_base.dart';

// Engine
export 'src/engine/inference_port.dart';
export 'src/engine/device_capabilities.dart';
export 'src/engine/device_capabilities_repository.dart';
export 'src/engine/sqflite_device_capabilities_repository.dart';
export 'src/engine/capability_detector.dart';
export 'src/engine/protocol.dart';
export 'src/engine/subprocess_engine.dart';
export 'src/engine/engine_exceptions.dart';
export 'src/engine/wire_guard.dart';

// Storage
export 'src/storage/database.dart';
export 'src/storage/storage_service.dart';

// Chat
export 'src/chat/message.dart';
export 'src/chat/conversation.dart';
export 'src/chat/chat_repository.dart';
export 'src/chat/sqflite_chat_repository.dart';
export 'src/chat/chat_service.dart';
export 'src/chat/reasoning_split.dart';

// Speech
export 'src/speech/transcription_port.dart';
export 'src/speech/stub_transcriber.dart';

// Models
export 'src/models/ai_model.dart';
export 'src/models/selected_model.dart';
export 'src/models/model_repository.dart';
export 'src/models/sqflite_model_repository.dart';
export 'src/models/model_manager.dart';
