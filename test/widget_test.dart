import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prompt_vault/app/app.dart';
import 'package:prompt_vault/features/prompts/data/prompt_providers.dart';
import 'package:prompt_vault/features/prompts/domain/prompt.dart';

class _EmptyPromptListNotifier extends PromptListNotifier {
  @override
  Future<List<Prompt>> build() async => [];
}

void main() {
  testWidgets('App loads library empty state', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          promptListProvider.overrideWith(_EmptyPromptListNotifier.new),
        ],
        child: const PromptVaultApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('PromptVault'), findsOneWidget);
    expect(find.text('No prompts yet'), findsOneWidget);
  });

  testWidgets('FAB navigates to new prompt editor', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          promptListProvider.overrideWith(_EmptyPromptListNotifier.new),
        ],
        child: const PromptVaultApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.textContaining('Editor placeholder'), findsOneWidget);
  });
}
