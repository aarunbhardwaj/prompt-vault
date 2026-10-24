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
