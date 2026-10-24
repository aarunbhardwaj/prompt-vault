import 'package:prompt_vault/features/prompts/domain/prompt.dart';
import 'package:prompt_vault/features/prompts/domain/prompt_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences key: starter library has been imported once.
const starterSeededPrefKey = 'starter_seeded';

/// Inserts [prompts] when no row exists for the same id (no overwrites).
Future<void> importStarterPrompts(
  PromptRepository repository,
  List<Prompt> prompts,
) async {
  for (final prompt in prompts) {
    final existing = await repository.getById(prompt.id);
    if (existing == null) {
      await repository.create(prompt);
    }
  }
}

/// Seeds starters on first launch only; sets [starterSeededPrefKey] when done.
Future<void> runFirstLaunchSeed({
  required SharedPreferences prefs,
  required PromptRepository repository,
  required Future<List<Prompt>> Function() loadPrompts,
}) async {
  if (prefs.getBool(starterSeededPrefKey) ?? false) {
    return;
  }
  final prompts = await loadPrompts();
  await importStarterPrompts(repository, prompts);
  await prefs.setBool(starterSeededPrefKey, true);
}

/// Re-imports bundled starters; skips prompts whose id already exists.
Future<int> restoreStarterPrompts({
  required PromptRepository repository,
  required Future<List<Prompt>> Function() loadPrompts,
}) async {
  final prompts = await loadPrompts();
  var imported = 0;
  for (final prompt in prompts) {
    final existing = await repository.getById(prompt.id);
    if (existing == null) {
      await repository.create(prompt);
      imported++;
    }
  }
  return imported;
}
