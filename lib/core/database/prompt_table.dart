/// v1 SQLite schema for prompts (columns align with [Prompt] domain model).
class PromptTable {
  PromptTable._();

  static const String tableName = 'prompts';

  static const String createSql =
      '''
CREATE TABLE $tableName (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  is_favorite INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)
''';
}
