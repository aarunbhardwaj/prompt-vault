import 'package:prompt_vault/features/prompts/domain/prompt.dart';

abstract class PromptRepository {
  Future<Prompt> create(Prompt prompt);

  Future<Prompt?> getById(String id);

  Future<Prompt> update(Prompt prompt);

  Future<void> delete(String id);

  Future<List<Prompt>> getAll();

  Future<List<Prompt>> search(String query);

  Future<Prompt> toggleFavorite(String id);
}
