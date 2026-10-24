import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prompt_vault/features/prompts/data/prompt_providers.dart';
import 'package:prompt_vault/features/prompts/domain/prompt.dart';
import 'package:prompt_vault/features/prompts/domain/prompt_repository.dart';

class FakePromptRepository implements PromptRepository {
  FakePromptRepository(this.prompts);

  List<Prompt> prompts;

  @override
  Future<Prompt> create(Prompt prompt) async {
    prompts.add(prompt);
    return prompt;
  }

  @override
  Future<void> delete(String id) async {
    prompts.removeWhere((p) => p.id == id);
  }

  @override
  Future<List<Prompt>> getAll() async => List.from(prompts);

  @override
  Future<Prompt?> getById(String id) async =>
      prompts.cast<Prompt?>().firstWhere((p) => p?.id == id, orElse: () => null);

  @override
  Future<List<Prompt>> search(String query) async {
    final q = query.toLowerCase();
    return prompts
        .where(
          (p) =>
              p.title.toLowerCase().contains(q) ||
              p.body.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Future<Prompt> toggleFavorite(String id) async {
    final index = prompts.indexWhere((p) => p.id == id);
    final updated = prompts[index].copyWith(isFavorite: !prompts[index].isFavorite);
    prompts[index] = updated;
    return updated;
  }

  @override
  Future<Prompt> update(Prompt prompt) async {
    final index = prompts.indexWhere((p) => p.id == prompt.id);
    prompts[index] = prompt;
    return prompt;
  }
}

class _PromptCountLabel extends ConsumerWidget {
  const _PromptCountLabel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPrompts = ref.watch(promptListProvider);
    return asyncPrompts.when(
      data: (list) => Text('count:${list.length}'),
      loading: () => const Text('loading'),
      error: (error, stackTrace) => Text('error:$error'),
    );
  }
}

void main() {
  testWidgets('promptListProvider uses overridden repository', (tester) async {
    final fake = FakePromptRepository([
      Prompt(
        id: '1',
        title: 'A',
        body: 'B',
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
      ),
    ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          promptRepositoryProvider.overrideWithValue(fake),
        ],
        child: const MaterialApp(home: Scaffold(body: _PromptCountLabel())),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('count:1'), findsOneWidget);
  });
}
