import 'package:go_router/go_router.dart';

import '../features/chat/presentation/screens/chat_screen.dart';

/// App routes. Grows as features land (models, settings, deepsearch …).
final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ChatScreen()),
  ],
);
