import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prompt_vault/core/database/app_database.dart';
import 'package:prompt_vault/features/prompts/data/sqflite_prompt_repository.dart';
import 'package:prompt_vault/features/prompts/domain/prompt.dart';
import 'package:prompt_vault/features/prompts/domain/prompt_repository.dart';
import 'package:prompt_vault/features/starter/data/starter_providers.dart';
import 'package:sqflite/sqflite.dart';

/// Opens the app SQLite database (singleton via [AppDatabase]).
final appDatabaseProvider = FutureProvider<Database>((ref) async {
  final db = await AppDatabase.open();
  ref.onDispose(AppDatabase.close);
  return db;
});

/// [PromptRepository] backed by sqflite.
final promptRepositoryProvider = Provider<PromptRepository>((ref) {
  final db = ref.watch(appDatabaseProvider).requireValue;
  return SqflitePromptRepository(db);
});

/// All prompts, refreshed after mutations via [PromptListNotifier].
final promptListProvider =
    AsyncNotifierProvider<PromptListNotifier, List<Prompt>>(
      PromptListNotifier.new,
    );

class PromptListNotifier extends AsyncNotifier<List<Prompt>> {
  PromptRepository get _repository => ref.read(promptRepositoryProvider);

  @override
  Future<List<Prompt>> build() async {
    await ref.watch(appDatabaseProvider.future);
    await ref.watch(starterSeedProvider.future);
    return _repository.getAll();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _repository.getAll());
  }

  Future<void> createPrompt(Prompt prompt) async {
    await _repository.create(prompt);
    await refresh();
  }

  Future<void> updatePrompt(Prompt prompt) async {
    await _repository.update(prompt);
    await refresh();
  }

  Future<void> deletePrompt(String id) async {
    await _repository.delete(id);
    await refresh();
  }

  Future<void> toggleFavorite(String id) async {
    await _repository.toggleFavorite(id);
    await refresh();
  }

  Future<List<Prompt>> search(String query) => _repository.search(query);
}

/// Current library search text (debounced in UI before update).
final librarySearchQueryProvider = StateProvider<String>((ref) => '');

/// When true, library shows only prompts with `isFavorite`.
final libraryFavoritesOnlyProvider = StateProvider<bool>((ref) => false);

/// Single prompt for edit screen (loads from repository).
final promptByIdProvider = FutureProvider.family<Prompt?, String>((
  ref,
  id,
) async {
  await ref.watch(appDatabaseProvider.future);
  return ref.read(promptRepositoryProvider).getById(id);
});

/// Prompts shown in the library (search + optional favorites filter).
final libraryVisiblePromptsProvider = FutureProvider<List<Prompt>>((ref) async {
  final query = ref.watch(librarySearchQueryProvider).trim();
  final favoritesOnly = ref.watch(libraryFavoritesOnlyProvider);

  final List<Prompt> prompts;
  if (query.isEmpty) {
    prompts = await ref.watch(promptListProvider.future);
  } else {
    prompts = await ref.read(promptListProvider.notifier).search(query);
  }

  if (favoritesOnly) {
    return prompts.where((p) => p.isFavorite).toList();
  }
  return prompts;
});
