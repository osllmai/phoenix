/// Phoenix on-device LLM core (pure Dart).
///
/// Public SDK surface: the [PhoenixCore] facade plus the engine, service, and
/// entity types a host (Flutter UI, HTTP gateway, CLI) needs.
library;

// Facade
export 'src/phoenix_core_base.dart';

// Engine
export 'src/engine/inference_port.dart';
export 'src/engine/protocol.dart';
export 'src/engine/subprocess_engine.dart';
export 'src/engine/engine_exceptions.dart';
export 'src/engine/wire_guard.dart';

// Storage
export 'src/storage/database.dart';

// Chat
export 'src/chat/message.dart';
export 'src/chat/conversation.dart';
export 'src/chat/chat_repository.dart';
export 'src/chat/sqflite_chat_repository.dart';
export 'src/chat/chat_service.dart';

// Speech
export 'src/speech/transcription_port.dart';
export 'src/speech/stub_transcriber.dart';

// Models
export 'src/models/ai_model.dart';
export 'src/models/model_repository.dart';
export 'src/models/sqflite_model_repository.dart';
export 'src/models/model_manager.dart';
