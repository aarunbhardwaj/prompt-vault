import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:prompt_vault/features/prompts/domain/prompt.dart';

const starterPromptsAssetPath = 'assets/starter_prompts.json';

/// Loads bundled starter prompts from the asset bundle.
Future<List<Prompt>> loadStarterPromptsFromAsset() async {
  final raw = await rootBundle.loadString(starterPromptsAssetPath);
  final list = jsonDecode(raw) as List<dynamic>;
  return list
      .map((e) => Prompt.fromJson(e as Map<String, dynamic>))
      .toList(growable: false);
}
