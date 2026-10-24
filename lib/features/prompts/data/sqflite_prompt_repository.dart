import 'package:prompt_vault/features/prompts/data/prompt_row_mapper.dart';
import 'package:prompt_vault/features/prompts/domain/prompt.dart';
import 'package:prompt_vault/features/prompts/domain/prompt_repository.dart';
import 'package:sqflite/sqflite.dart';

class SqflitePromptRepository implements PromptRepository {
  SqflitePromptRepository(this._db);

  final Database _db;

  @override
  Future<Prompt> create(Prompt prompt) async {
    await _db.insert(
      promptTableName,
      promptToRow(prompt),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
    return prompt;
  }

  @override
  Future<void> delete(String id) async {
    await _db.delete(promptTableName, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Prompt>> getAll() async {
    final rows = await _db.query(promptTableName, orderBy: 'updated_at DESC');
    return rows.map(promptFromRow).toList();
  }

  @override
  Future<Prompt?> getById(String id) async {
    final rows = await _db.query(
      promptTableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return promptFromRow(rows.first);
  }

  @override
  Future<List<Prompt>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return getAll();
    }
    final pattern = '%${trimmed.replaceAll('%', '')}%';
    final rows = await _db.query(
      promptTableName,
      where: 'title LIKE ? COLLATE NOCASE OR body LIKE ? COLLATE NOCASE',
      whereArgs: [pattern, pattern],
      orderBy: 'updated_at DESC',
    );
    return rows.map(promptFromRow).toList();
  }

  @override
  Future<Prompt> toggleFavorite(String id) async {
    final existing = await getById(id);
    if (existing == null) {
      throw StateError('Prompt not found: $id');
    }
    final updated = existing.copyWith(
      isFavorite: !existing.isFavorite,
      updatedAt: DateTime.now().toUtc(),
    );
    await update(updated);
    return updated;
  }

  @override
  Future<Prompt> update(Prompt prompt) async {
    final count = await _db.update(
      promptTableName,
      promptToRow(prompt),
      where: 'id = ?',
      whereArgs: [prompt.id],
    );
    if (count == 0) {
      throw StateError('Prompt not found: ${prompt.id}');
    }
    return prompt;
  }
}
