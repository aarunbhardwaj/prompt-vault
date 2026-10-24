import 'package:flutter_test/flutter_test.dart';
import 'package:prompt_vault/features/prompts/domain/prompt.dart';

void main() {
  test('Prompt JSON round-trip', () {
    final original = Prompt(
      id: 'abc',
      title: 'Title',
      body: 'Body with {{var}}',
      isFavorite: true,
      createdAt: DateTime.utc(2026, 1, 2, 3, 4, 5),
      updatedAt: DateTime.utc(2026, 1, 3, 4, 5, 6),
    );

    final json = original.toJson();
    final restored = Prompt.fromJson(json);

    expect(restored, original);
  });
}
