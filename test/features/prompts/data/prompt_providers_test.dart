import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prompt_vault/features/prompts/data/prompt_providers.dart';
import 'package:prompt_vault/features/prompts/domain/prompt.dart';
class _OnePromptListNotifier extends PromptListNotifier {
  @override
  Future<List<Prompt>> build() async => [
        Prompt(
          id: '1',
          title: 'A',
          body: 'B',
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
        ),
      ];
}

class _SearchablePromptListNotifier extends PromptListNotifier {
  @override
  Future<List<Prompt>> build() async => [
        Prompt(
          id: '1',
          title: 'Alpha',
          body: 'x',
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
        ),
        Prompt(
          id: '2',
          title: 'Beta',
          body: 'y',
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
        ),
      ];

  @override
  Future<List<Prompt>> search(String query) async {
    final q = query.trim().toLowerCase();
    final all = await build();
    return all.where((p) => p.title.toLowerCase().contains(q)).toList();
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
  test('libraryVisiblePromptsProvider filters via search on mock list', () async {
    final container = ProviderContainer(
      overrides: [
        promptListProvider.overrideWith(_SearchablePromptListNotifier.new),
      ],
    );
    addTearDown(container.dispose);

    container.read(librarySearchQueryProvider.notifier).state = 'alp';
    final visible = await container.read(libraryVisiblePromptsProvider.future);

    expect(visible.map((p) => p.title), ['Alpha']);
  });

  testWidgets('promptListProvider can be overridden in tests', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          promptListProvider.overrideWith(_OnePromptListNotifier.new),
        ],
        child: const MaterialApp(home: Scaffold(body: _PromptCountLabel())),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('count:1'), findsOneWidget);
  });
}
