import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prompt_vault/core/utils/prompt_template.dart';
import 'package:prompt_vault/features/prompts/domain/prompt.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('starter_prompts.json parses and includes template variables', () async {
    final raw = await rootBundle.loadString('assets/starter_prompts.json');
    final list = jsonDecode(raw) as List<dynamic>;
    expect(list.length, 15);

    final prompts = list
        .map((e) => Prompt.fromJson(e as Map<String, dynamic>))
        .toList();

    expect(prompts.every((p) => p.id.startsWith('starter-')), isTrue);

    final withVars = prompts.where(
      (p) => extractVariables(p.body).isNotEmpty,
    );
    expect(withVars.length, greaterThanOrEqualTo(10));
  });
}
