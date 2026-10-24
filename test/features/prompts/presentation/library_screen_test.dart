import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prompt_vault/features/prompts/data/prompt_providers.dart';
import 'package:prompt_vault/features/prompts/domain/prompt.dart';
import 'package:prompt_vault/features/prompts/presentation/library_screen.dart';

class _TestPromptListNotifier extends PromptListNotifier {
  _TestPromptListNotifier(this.prompts);

  final List<Prompt> prompts;

  @override
  Future<List<Prompt>> build() async => prompts;
}

void main() {
  testWidgets('empty state shows hint', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          promptListProvider.overrideWith(() => _TestPromptListNotifier([])),
        ],
        child: const MaterialApp(home: LibraryScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No prompts yet'), findsOneWidget);
    expect(find.text('Tap + to add your first prompt.'), findsOneWidget);
  });

  testWidgets('renders prompt cards', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          promptListProvider.overrideWith(
            () => _TestPromptListNotifier([
              Prompt(
                id: 'a',
                title: 'My prompt',
                body: 'Body text here',
                createdAt: DateTime.utc(2026, 1, 1),
                updatedAt: DateTime.utc(2026, 1, 1),
              ),
            ]),
          ),
        ],
        child: const MaterialApp(home: LibraryScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('My prompt'), findsOneWidget);
    expect(find.text('Body text here'), findsOneWidget);
  });

  testWidgets('shows empty search results state', (tester) async {
    final sample = Prompt(
      id: 'a',
      title: 'My prompt',
      body: 'Body',
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          promptListProvider.overrideWith(
            () => _TestPromptListNotifier([sample]),
          ),
          librarySearchQueryProvider.overrideWith((ref) => 'nomatch'),
          libraryVisiblePromptsProvider.overrideWith((ref) async => []),
        ],
        child: const MaterialApp(home: LibraryScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No results'), findsOneWidget);
    expect(find.textContaining('nomatch'), findsOneWidget);
  });

  testWidgets('favorites filter shows only starred prompts', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          promptListProvider.overrideWith(
            () => _TestPromptListNotifier([
              Prompt(
                id: '1',
                title: 'Fav',
                body: 'b',
                isFavorite: true,
                createdAt: DateTime.utc(2026, 1, 1),
                updatedAt: DateTime.utc(2026, 1, 1),
              ),
              Prompt(
                id: '2',
                title: 'Other',
                body: 'b',
                createdAt: DateTime.utc(2026, 1, 1),
                updatedAt: DateTime.utc(2026, 1, 1),
              ),
            ]),
          ),
          libraryFavoritesOnlyProvider.overrideWith((ref) => true),
          libraryVisiblePromptsProvider.overrideWith(
            (ref) async => [
              Prompt(
                id: '1',
                title: 'Fav',
                body: 'b',
                isFavorite: true,
                createdAt: DateTime.utc(2026, 1, 1),
                updatedAt: DateTime.utc(2026, 1, 1),
              ),
            ],
          ),
        ],
        child: const MaterialApp(home: LibraryScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Fav'), findsOneWidget);
    expect(find.text('Other'), findsNothing);
  });

  testWidgets('prompt cards are dismissible for delete', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          promptListProvider.overrideWith(
            () => _TestPromptListNotifier([
              Prompt(
                id: 'a',
                title: 'Swipe me',
                body: 'b',
                createdAt: DateTime.utc(2026, 1, 1),
                updatedAt: DateTime.utc(2026, 1, 1),
              ),
            ]),
          ),
        ],
        child: const MaterialApp(home: LibraryScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Dismissible), findsOneWidget);
  });
}
