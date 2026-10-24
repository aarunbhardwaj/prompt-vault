import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prompt_vault/features/prompts/data/prompt_providers.dart';
import 'package:prompt_vault/features/starter/data/starter_prompts_loader.dart';
import 'package:prompt_vault/features/starter/data/starter_seed_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return SharedPreferences.getInstance();
});

/// Runs once per install: seeds starter prompts when [starterSeededPrefKey] is false.
final starterSeedProvider = FutureProvider<void>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  await ref.watch(appDatabaseProvider.future);
  final repository = ref.read(promptRepositoryProvider);
  await runFirstLaunchSeed(
    prefs: prefs,
    repository: repository,
    loadPrompts: loadStarterPromptsFromAsset,
  );
});

/// Restores missing starter prompts from the asset bundle (by id).
Future<int> restoreStarterPromptsFromAsset(WidgetRef ref) async {
  await ref.watch(appDatabaseProvider.future);
  final repository = ref.read(promptRepositoryProvider);
  final count = await restoreStarterPrompts(
    repository: repository,
    loadPrompts: loadStarterPromptsFromAsset,
  );
  ref.invalidate(promptListProvider);
  return count;
}
