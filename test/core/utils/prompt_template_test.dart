import 'package:flutter_test/flutter_test.dart';
import 'package:prompt_vault/core/utils/prompt_template.dart';

void main() {
  group('extractVariables', () {
    test('returns empty for empty template', () {
      expect(extractVariables(''), isEmpty);
    });

    test('returns unique names in first-seen order', () {
      expect(
        extractVariables('{{topic}} about {{tone}} and {{topic}}'),
        ['topic', 'tone'],
      );
    });

    test('ignores invalid placeholder names', () {
      expect(extractVariables('{{ topic }} {{ok_var}}'), ['ok_var']);
    });
  });

  group('substitute', () {
    test('replaces multiple and repeated placeholders', () {
      final result = substitute(
        'Write about {{topic}} in {{tone}} tone for {{topic}}.',
        {'topic': 'AI', 'tone': 'friendly'},
      );
      expect(result, 'Write about AI in friendly tone for AI.');
    });

    test('empty template stays empty', () {
      expect(substitute('', {'x': 'y'}), '');
    });

    test('unknown keys leave placeholder unchanged', () {
      expect(
        substitute('Hello {{name}}, {{missing}}', {'name': 'Ada'}),
        'Hello Ada, {{missing}}',
      );
    });
  });
}
