import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prompt_vault/app/app.dart';

void main() {
  testWidgets('Library placeholder loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PromptVaultApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('PromptVault Library'), findsOneWidget);
    expect(find.text('New prompt'), findsWidgets);
  });

  testWidgets('Dev navigation reaches editor and runner', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PromptVaultApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Edit sample prompt'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Editor placeholder'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Run sample prompt'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Runner placeholder'), findsOneWidget);
  });
}
