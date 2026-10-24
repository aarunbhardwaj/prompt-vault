import 'package:prompt_vault/core/database/prompt_table.dart';
import 'package:prompt_vault/features/prompts/domain/prompt.dart';

Map<String, Object?> promptToRow(Prompt prompt) {
  return {
    'id': prompt.id,
    'title': prompt.title,
    'body': prompt.body,
    'is_favorite': prompt.isFavorite ? 1 : 0,
    'created_at': prompt.createdAt.toUtc().toIso8601String(),
    'updated_at': prompt.updatedAt.toUtc().toIso8601String(),
  };
}

Prompt promptFromRow(Map<String, Object?> row) {
  return Prompt(
    id: row['id']! as String,
    title: row['title']! as String,
    body: row['body']! as String,
    isFavorite: (row['is_favorite']! as int) != 0,
    createdAt: DateTime.parse(row['created_at']! as String),
    updatedAt: DateTime.parse(row['updated_at']! as String),
  );
}

String get promptTableName => PromptTable.tableName;
