import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prompt_vault/features/prompts/presentation/editor_placeholder_screen.dart';
import 'package:prompt_vault/features/prompts/presentation/library_placeholder_screen.dart';
import 'package:prompt_vault/features/prompts/presentation/runner_placeholder_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LibraryPlaceholderScreen(),
      ),
      GoRoute(
        path: '/prompt/new',
        builder: (context, state) => const EditorPlaceholderScreen(),
      ),
      GoRoute(
        path: '/prompt/:id/edit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return EditorPlaceholderScreen(promptId: id);
        },
      ),
      GoRoute(
        path: '/prompt/:id/run',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return RunnerPlaceholderScreen(promptId: id);
        },
      ),
    ],
  );
});
