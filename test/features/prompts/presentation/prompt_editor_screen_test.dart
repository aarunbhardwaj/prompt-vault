import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:prompt_vault/features/prompts/data/prompt_providers.dart';
import 'package:prompt_vault/features/prompts/domain/prompt.dart';
import 'package:prompt_vault/features/prompts/presentation/prompt_editor_screen.dart';

class _RecordingPromptListNotifier extends PromptListNotifier {
  Prompt? created;
  Prompt? updated;

  @override
  Future<List<Prompt>> build() async => [];

  @override
  Future<void> createPrompt(Prompt prompt) async {
    created = prompt;
  }

  @override
  Future<void> updatePrompt(Prompt prompt) async {
    updated = prompt;
  }
}

GoRouter _testRouter(Widget child) {
  return GoRouter(
    initialLocation: '/editor',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const Scaffold(body: Text('Library'))),
      GoRoute(path: '/editor', builder: (context, state) => child),
    ],
  );
}

void main() {
  testWidgets('save with empty fields shows inline errors', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          promptListProvider.overrideWith(_RecordingPromptListNotifier.new),
        ],
        child: MaterialApp.router(
          routerConfig: _testRouter(const PromptEditorScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Title is required'), findsOneWidget);
    expect(find.text('Body is required'), findsOneWidget);
  });

  testWidgets('save create persists and returns to library', (tester) async {
    final notifier = _RecordingPromptListNotifier();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          promptListProvider.overrideWith(() => notifier),
        ],
        child: MaterialApp.router(
          routerConfig: _testRouter(const PromptEditorScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Title'), 'Hello');
    await tester.enterText(find.widgetWithText(TextField, 'Body'), 'World');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(notifier.created?.title, 'Hello');
    expect(notifier.created?.body, 'World');
    expect(find.text('Library'), findsOneWidget);
  });

  testWidgets('edit mode loads prompt and saves update', (tester) async {
    final existing = Prompt(
      id: 'edit-1',
      title: 'Old',
      body: 'Old body',
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );
    final notifier = _RecordingPromptListNotifier();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          promptListProvider.overrideWith(() => notifier),
          promptByIdProvider('edit-1').overrideWith((ref) async => existing),
        ],
        child: MaterialApp.router(
          routerConfig: _testRouter(
            const PromptEditorScreen(promptId: 'edit-1'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Old'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Title'), 'New title');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(notifier.updated?.title, 'New title');
    expect(notifier.updated?.body, 'Old body');
    expect(find.text('Library'), findsOneWidget);
  });
}
