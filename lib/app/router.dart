import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prompt_vault/features/prompts/presentation/prompt_editor_screen.dart';
import 'package:prompt_vault/features/prompts/presentation/library_screen.dart';
import 'package:prompt_vault/features/prompts/presentation/prompt_runner_screen.dart';
import 'package:prompt_vault/features/settings/presentation/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LibraryScreen()),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/prompt/new',
        builder: (context, state) => const PromptEditorScreen(),
      ),
      GoRoute(
        path: '/prompt/:id/edit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PromptEditorScreen(promptId: id);
        },
      ),
      GoRoute(
        path: '/prompt/:id/run',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PromptRunnerScreen(promptId: id);
        },
      ),
    ],
  );
});
