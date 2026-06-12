import 'package:go_router/go_router.dart';

import '../features/chat/presentation/screens/chat_screen.dart';
import '../features/models/presentation/screens/models_screen.dart';

/// App routes. Grows as features land (settings, deepsearch …).
final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ChatScreen()),
    GoRoute(path: '/models', builder: (context, state) => const ModelsScreen()),
  ],
);
