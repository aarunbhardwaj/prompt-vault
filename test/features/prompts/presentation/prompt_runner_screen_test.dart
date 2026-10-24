import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prompt_vault/features/prompts/data/prompt_providers.dart';
import 'package:prompt_vault/features/prompts/domain/prompt.dart';
import 'package:prompt_vault/features/prompts/presentation/prompt_runner_screen.dart';

void main() {
  testWidgets('shows one field per detected variable', (tester) async {
    final prompt = Prompt(
      id: 'r1',
      title: 'Blog post',
      body: 'Write about {{topic}} in {{tone}} tone.',
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          promptByIdProvider('r1').overrideWith((ref) async => prompt),
        ],
        child: MaterialApp(
          home: PromptRunnerScreen(promptId: 'r1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Variables'), findsOneWidget);
    expect(find.text('Topic'), findsOneWidget);
    expect(find.text('Tone'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('skips variable section when template has no placeholders', (
    tester,
  ) async {
    final prompt = Prompt(
      id: 'r2',
      title: 'Plain',
      body: 'No placeholders here.',
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          promptByIdProvider('r2').overrideWith((ref) async => prompt),
        ],
        child: MaterialApp(
          home: PromptRunnerScreen(promptId: 'r2'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Variables'), findsNothing);
    expect(find.byType(TextField), findsNothing);
    expect(find.text('Preview'), findsOneWidget);
    expect(find.text('No placeholders here.'), findsOneWidget);
  });

  testWidgets('preview updates when variable values change', (tester) async {
    final prompt = Prompt(
      id: 'r3',
      title: 'Run',
      body: 'Hello {{name}}!',
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          promptByIdProvider('r3').overrideWith((ref) async => prompt),
        ],
        child: MaterialApp(
          home: PromptRunnerScreen(promptId: 'r3'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('{{name}}'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Ada');
    await tester.pump();

    expect(find.text('Hello Ada!'), findsOneWidget);
    expect(find.textContaining('{{name}}'), findsNothing);
  });

  testWidgets('runner fills variables preview and copy', (tester) async {
    String? clipboardText;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (message) async {
      if (message.method == 'Clipboard.setData') {
        final args = message.arguments as Map<dynamic, dynamic>;
        clipboardText = args['text'] as String?;
      }
      return null;
    });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    final prompt = Prompt(
      id: 'e4t4',
      title: 'Email',
      body: 'Draft about {{topic}} in a {{tone}} tone for {{topic}}.',
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          promptByIdProvider('e4t4').overrideWith((ref) async => prompt),
        ],
        child: MaterialApp(
          home: PromptRunnerScreen(promptId: 'e4t4'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Flutter');
    await tester.enterText(fields.at(1), 'friendly');
    await tester.pump();

    expect(
      find.text('Draft about Flutter in a friendly tone for Flutter.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Copy prompt'));
    await tester.pumpAndSettle();

    expect(
      clipboardText,
      'Draft about Flutter in a friendly tone for Flutter.',
    );
  });

  testWidgets('copy prompt writes substituted text to clipboard', (
    tester,
  ) async {
    String? clipboardText;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (message) async {
      if (message.method == 'Clipboard.setData') {
        final args = message.arguments as Map<dynamic, dynamic>;
        clipboardText = args['text'] as String?;
      }
      return null;
    });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    final prompt = Prompt(
      id: 'r4',
      title: 'Copy me',
      body: 'Hi {{name}}',
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          promptByIdProvider('r4').overrideWith((ref) async => prompt),
        ],
        child: MaterialApp(
          home: PromptRunnerScreen(promptId: 'r4'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Sam');
    await tester.pump();
    await tester.tap(find.text('Copy prompt'));
    await tester.pumpAndSettle();

    expect(clipboardText, 'Hi Sam');
    expect(find.text('Copied to clipboard'), findsOneWidget);
  });

  testWidgets('copy prompt uses body when no variables', (tester) async {
    String? clipboardText;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (message) async {
      if (message.method == 'Clipboard.setData') {
        final args = message.arguments as Map<dynamic, dynamic>;
        clipboardText = args['text'] as String?;
      }
      return null;
    });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    final prompt = Prompt(
      id: 'r5',
      title: 'Plain',
      body: 'Static body text',
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          promptByIdProvider('r5').overrideWith((ref) async => prompt),
        ],
        child: MaterialApp(
          home: PromptRunnerScreen(promptId: 'r5'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Copy prompt'));
    await tester.pumpAndSettle();

    expect(clipboardText, 'Static body text');
  });

  test('humanizeVariableName splits underscores', () {
    expect(humanizeVariableName('user_name'), 'User name');
    expect(humanizeVariableName('topic'), 'Topic');
  });
}
